import 'dart:ffi' as ffi;
import 'dart:io';
import 'dart:isolate';
import 'package:ffi/ffi.dart';

// ListenAndServe 함수
typedef ListenAndServeNative =
    ffi.Int32 Function(ffi.Pointer<Utf8> logPath, ffi.Bool displayTerminalLog);
typedef ListenAndServeDart =
    int Function(ffi.Pointer<Utf8> logPath, bool displayTerminalLog);

// 스레드 간 통신을 위한 메시지
class _IsolateMessage {
  final SendPort sendPort;
  final String libraryPath;
  final String logPath;
  final bool displayTerminalLog;

  _IsolateMessage(
    this.sendPort,
    this.libraryPath,
    this.logPath,
    this.displayTerminalLog,
  );
}

void _listenAndServeIsolate(_IsolateMessage message) async {
  try {
    // DLL/SO 로드
    final dylib = ffi.DynamicLibrary.open(message.libraryPath);

    // ListenAndServe 함수 바인딩
    final listenAndServe =
        dylib
            .lookup<ffi.NativeFunction<ListenAndServeNative>>('ListenAndServe')
            .asFunction<ListenAndServeDart>();

    message.sendPort.send('ListenAndServe Started');

    int result = listenAndServe(
      message.logPath.toNativeUtf8(),
      message.displayTerminalLog,
    );

    message.sendPort.send('ListenAndServe Completed. Result: $result');
  } catch (e) {
    message.sendPort.send('Error: $e');
  }
}

String _getLibraryPath(String libVersion) {
  if (Platform.isWindows) {
    return 'assets/libkanavi_lidar_sdk-vc143-x64-md-$libVersion.dll';
  } else if (Platform.isAndroid) {
    return 'libkanavi_lidar_sdk-$libVersion.so';
  } else if (Platform.isLinux) {
    return 'assets/libkanavi_lidar_sdk-gcc-x64-$libVersion.so';
  } else {
    throw UnsupportedError(
      'Not supported platform: ${Platform.operatingSystem}',
    );
  }
}

String _getLogPath() {
  if (Platform.isAndroid) {
    // Create log folder in Documents for easy access
    return '/storage/emulated/0/Documents/lidar_sdk_logs';
  } else {
    return 'logs';
  }
}

// LiDAR SDK 서버 Singleton 클래스
class LidarSDKServer {
  static LidarSDKServer? _instance;
  LidarSDKServer._();

  factory LidarSDKServer() {
    _instance ??= LidarSDKServer._();
    return _instance!;
  }

  static LidarSDKServer get instance => LidarSDKServer();

  ReceivePort? _receivePort;
  Isolate? _isolate;
  bool _isRunning = false;
  String _status = 'ready';
  final List<Function(String)> _statusListeners = [];

  void addStatusListener(Function(String) listener) {
    _statusListeners.add(listener);
  }

  void removeStatusListener(Function(String) listener) {
    _statusListeners.remove(listener);
  }

  void clearStatusListeners() {
    _statusListeners.clear();
  }

  bool get isRunning => _isRunning;

  String get status => _status;

  Future<void> start({
    String libVersion = "1.0.0",
    String customLogPath = "",
    bool displayTerminalLog = false,
  }) async {
    if (_isRunning) {
      print('LiDAR SDK is already running');
      return;
    }

    try {
      _receivePort = ReceivePort();
      String libraryPath = _getLibraryPath(libVersion);
      String logFolderPath =
          customLogPath.isEmpty ? _getLogPath() : customLogPath;

      // Create log folder
      try {
        if (!Directory(logFolderPath).existsSync()) {
          Directory(logFolderPath).createSync(recursive: true);
          print('Log folder created: $logFolderPath');
        }
      } catch (e) {
        print('Log folder creation failed: $e');
      }

      _isolate = await Isolate.spawn(
        _listenAndServeIsolate,
        _IsolateMessage(
          _receivePort!.sendPort,
          libraryPath,
          logFolderPath,
          displayTerminalLog,
        ),
      );

      _isRunning = true;
      _updateStatus('LiDAR SDK started');

      _receivePort!.listen((message) {
        _updateStatus(message.toString());
        print('LiDAR SDK: $message');
      });

      print('LiDAR SDK server started successfully');
    } catch (e) {
      _updateStatus('Start failed: $e');
      print('LiDAR SDK start failed: $e');
    }
  }

  void stop() {
    if (!_isRunning) {
      print('LiDAR SDK is not running');
      return;
    }

    try {
      _isolate?.kill(priority: Isolate.immediate);
      _receivePort?.close();
      _isolate = null;
      _receivePort = null;
      _isRunning = false;
      _updateStatus('LiDAR SDK stopped');
      print('LiDAR SDK server stopped');
    } catch (e) {
      print('LiDAR SDK stop failed: $e');
    }
  }

  void _updateStatus(String newStatus) {
    _status = newStatus;
    for (var listener in _statusListeners) {
      try {
        listener(newStatus);
      } catch (e) {
        print('Status listener error: $e');
      }
    }
  }

  void dispose() {
    stop();
    clearStatusListeners();
  }
}

LidarSDKServer get lidarSDK => LidarSDKServer.instance;
