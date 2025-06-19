import 'dart:convert';
import 'dart:isolate';
import 'package:example/services/lidar_sdk_server.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

// LiDAR SDK 상태 관리 클래스
class LidarService {
  static ReceivePort? _receivePort;
  static bool _isRunning = false;
  static Function(String)? _onStatusChange;

  static void setStatusListener(Function(String) listener) {
    _onStatusChange = listener;
  }

  static bool get isRunning => _isRunning;
  static String get status => LidarSDKServer.instance.status;

  static Future<void> start({String libVersion = "1.0.0"}) async {
    if (_isRunning) return;
    LidarSDKServer.instance.start(libVersion: libVersion);

    _isRunning = true;
  }
}

// WebSocket 관리 클래스
class WebSocketService {
  static WebSocketChannel? _channel;
  static bool _isConnected = false;
  static Function(String)? _onMessageReceived;
  static Function(bool)? _onConnectionChanged;

  static bool get isConnected => _isConnected;

  static void setMessageListener(Function(String) listener) {
    _onMessageReceived = listener;
  }

  static void setConnectionListener(Function(bool) listener) {
    _onConnectionChanged = listener;
  }

  static Future<void> connect(String url) async {
    try {
      _channel = WebSocketChannel.connect(Uri.parse(url));
      _isConnected = true;
      _onConnectionChanged?.call(true);

      _channel!.stream.listen(
        (message) {
          _onMessageReceived?.call(message.toString());
        },
        onError: (error) {
          _isConnected = false;
          _onConnectionChanged?.call(false);
          _onMessageReceived?.call('WebSocket 에러: $error');
        },
        onDone: () {
          _isConnected = false;
          _onConnectionChanged?.call(false);
          _onMessageReceived?.call('WebSocket 연결 끊어짐');
        },
      );
    } catch (e) {
      _isConnected = false;
      _onConnectionChanged?.call(false);
      _onMessageReceived?.call('연결 실패: $e');
    }
  }

  static void sendMessage(Map<String, dynamic> message) {
    if (_isConnected && _channel != null) {
      _channel!.sink.add(jsonEncode(message));
    }
  }

  static void disconnect() {
    _channel?.sink.close();
    _isConnected = false;
    _onConnectionChanged?.call(false);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // LiDAR SDK 시작
  await LidarService.start(libVersion: "1.0.0");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LiDAR SDK',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const LidarScreen(),
    );
  }
}

class LidarScreen extends StatefulWidget {
  const LidarScreen({super.key});

  @override
  State<LidarScreen> createState() => _LidarScreenState();
}

class _LidarScreenState extends State<LidarScreen> {
  String _status = LidarService.status;
  bool _isWebSocketConnected = false;
  final TextEditingController _portController = TextEditingController();
  final TextEditingController _deviceIdController = TextEditingController();
  final TextEditingController _urlController = TextEditingController(
    text: 'ws://localhost:5555',
  );
  final ScrollController _scrollController = ScrollController();
  List<String> _receivedMessages = [];

  @override
  void initState() {
    super.initState();

    LidarService.setStatusListener((status) {
      setState(() {
        _status = status;
      });
    });

    WebSocketService.setConnectionListener((connected) {
      setState(() {
        _isWebSocketConnected = connected;
      });
    });

    WebSocketService.setMessageListener((message) {
      setState(() {
        _receivedMessages.add(
          '[${DateTime.now().toString().substring(11, 19)}] $message',
        );
      });
      // 자동 스크롤
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
          );
        }
      });
    });
  }

  void _connectWebSocket() {
    WebSocketService.connect(_urlController.text);
  }

  void _disconnectWebSocket() {
    WebSocketService.disconnect();
  }

  // get_list
  void _getDeviceList() {
    WebSocketService.sendMessage({
      "type": "request",
      "request_id": "1",
      "device_id": null,
      "data": {
        "action": "get_device_list",
        "params": {"port": int.tryParse(_portController.text) ?? 5000},
      },
    });
  }

  void _scanStart() {
    WebSocketService.sendMessage({
      "type": "request",
      "request_id": "1",
      "device_id": null,
      "data": {
        "action": "subscribe_devices",
        "params": [
          {
            "ip": int.tryParse(_deviceIdController.text.split(',')[0]) ?? 0,
            "port": int.tryParse(_deviceIdController.text.split(',')[1]) ?? 0,
            "model": int.tryParse(_deviceIdController.text.split(',')[2]) ?? 0,
            "id": int.tryParse(_deviceIdController.text.split(',')[3]) ?? 0,
          },
        ],
      },
    });
  }

  void _stopScan() {
    WebSocketService.sendMessage({
      "type": "request",
      "request_id": "1",
      "device_id": null,
      "data": {"action": "subscribe_devices", "params": []},
    });
  }

  void _clearMessages() {
    setState(() {
      _receivedMessages.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('LiDAR SDK Monitor'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // WebSocket 연결 섹션
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withAlpha(100),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'WebSocket 연결',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _urlController,
                    decoration: const InputDecoration(
                      labelText: 'WebSocket URL',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed:
                              !_isWebSocketConnected ? _connectWebSocket : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('연결'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed:
                              _isWebSocketConnected
                                  ? _disconnectWebSocket
                                  : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('연결해제'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 메시지 전송 버튼들
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withAlpha(100),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _portController,
                          decoration: const InputDecoration(
                            labelText: 'port',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed:
                              _isWebSocketConnected ? _getDeviceList : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('장치 목록 조회'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withAlpha(100),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _deviceIdController,
                          decoration: const InputDecoration(
                            labelText: 'device_id',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _isWebSocketConnected ? _scanStart : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('스캔 시작'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withAlpha(100),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _deviceIdController,
                          decoration: const InputDecoration(
                            labelText: 'device_id',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _isWebSocketConnected ? _stopScan : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('스캔 중지'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 수신 메시지 표시 영역
            Container(
              width: double.infinity,
              height: 300,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withAlpha(100),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '수신 메시지',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        ElevatedButton(
                          onPressed: _clearMessages,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(60, 30),
                          ),
                          child: const Text('지우기'),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: _receivedMessages.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 2),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              _receivedMessages[index],
                              style: const TextStyle(
                                fontFamily: 'Courier',
                                fontSize: 12,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _portController.dispose();
    _urlController.dispose();
    _scrollController.dispose();
    WebSocketService.disconnect();
    super.dispose();
  }
}
