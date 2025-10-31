# Response Message

## Response 형식

| 필드 | 타입 | 설명 |
| - | - | - |
| `request_id` | `string`| 요청 식별자 (client에서 지정) |
| `status` | `string` | 응답 상태 |
| `data` | [`Response Data`](#response-data) |응답 데이터 |

---

## Response Data

| 타입 | 설명 |
| - | - |
| [`DefaultResponse`](#default-response) | 기본 응답(데이터 없음) |
| [`GetDeviceList`](#get-device-list-request) | Device ID 목록 |
| [`GetBasicInfo`](#get-basic-info-request) | 기본 설정 값 |
| [`GetVersionInfo`](#get-version-info-request) | 버전 정보 |
| [`GetTeachingMode`](#get-teaching-mode-request) | 티칭 모드 설정 값 |
| [`GetTeachingArea`](#get-teaching-area-request) | 티칭 영역 좌표 |
| [`GetMotorSpeed`](#get-motor-speed-request) | 모터 스피드 |
| [`GetWarningArea`](#get-warning-area-request) | 경고 영역 |
| [`GetFogFilter`](#get-fog-filter-request) | 안개 필터 |
| [`GetRadiusFilter`](#get-radius-filter-max-distance-request) | 오감지 필터 |
| [`GetRadiusFilterMaxDistance`](#get-radius-filter-max-distance-request) | 오감지 필터 최대 거리 |
| [`GetRadiusFilterMinDistance`](#get-radius-filter-min-distance-request) | 오감지 필터 최소 거리 |
| [`GetWindowContaminationDetectionMode`](#get-window-contamination-detection-mode-request) | 스크린 오염 감지 설정 값 |
| [`GetNetworkSourceInfo`](#get-network-source-info-request) | 네트워크 출발지 정보 |
| [`GetNetworkDestinationIp`](#get-network-destination-ip-request) | 네트워크 목적지 IP |
| [`GetNetworkInfo`](#get-network-info-request) | 네트워크 정보 |
| [`GetCloudPointFilter`](#get-cloud-point-filter-request) | 포인트 필터 설정 조회 |
| [`UploadFile`](#upload-file-request)|업로드된 파일 정보|
| [`DownloadFile`](#download-file-request)|다운로드된 파일 정보|
| [`GetFileList`](#get-file-list-request)|업로드 된 파일 목록|
| [`FirmwareUpdate`](#firmware-update-request)|펌웨어 업데이트 완료|

---

### Default Response

데이터가 필요 없는 응답

data 에 요청한 request의 [`action`](request.md#actions--params) 이 설정됨

```json
{
  "type": "response",
  "request_id": "100",
  "status": "success",
  "data": {
    "action": "reset-config", // 요청 한 request 의 action 값
    "params": null
  }
}
```

---

### Get Device List ([`Request`](request.md#get-device-list-response))

현재 연결된 LiDAR 기기들의 정보

```json
{
  "type": "response",
  "request_id": "50",
  "status": "success",
  "data": {
    "action": "get_device_list",
    "params": [
      {
        "ip": 3232267208,
        "port": 5000,
        "model": 6,
        "id": 208
      }
    ]
  }
}
```

---

### Get Basic Info ([`Request`](request.md#get-basic-info-response))

기본 설정 값 정보

```json
{
  "type": "response",
  "request_id": "100",
  "status": "success",
  "data": {
    "action": "get_basic_info",
    "params": {
      "output_channel": {
        "channel": [
          true,
          true,
          true,
          true,
          false,
          false,
          false,
          false
        ]
      },
      "self_check_active_state": {
        "active": false
      },
      "pulse_active_state": {
        "active": false
      },
      "detection_hold_time": {
        "time": 0 // [ms]
      },
      "pulse_pin_mode": {
        "mode": 0,
        "channel": 15
      },
      "hfov": {
        // [°]
        "start_angle": 0,
        "end_angle": 100
      },
      "distance_range": {
        // [m]
        "start_distance": 0,
        "end_distance": 100
      },
      "object_size": {
        "size": 0 // [cm]
      },
      "user_area": [
        {
          "area": [
            {
              "x": 0,
              "y": 0.03,
              "z": 0
            },
            {
              "x": -3.34,
              "y": 3.37,
              "z": 0
            },
            {
              "x": -2.25,
              "y": 4.44,
              "z": 0
            },
            {
              "x": 1.08,
              "y": 1.11,
              "z": 0
            }
          ]
        }
      ]
    }
  }
}
```

---

### Get Version Info ([`Request`](request.md#get-version-info-response))

LiDAR Firmware, Hardware 버전과 사용처에 대한 정보

```json
{
  "type": "response",
  "request_id": "100",
  "status": "success",
  "data": {
    "action": "get_version_info",
    "params": {
      "fw_version": "3.2.0",
      "hw_version": "6.0.0",
      "end_application": "General Purpose"
    }
  }
}
```

---

### Get Teaching Mode ([`Request`](request.md#get-teaching-mode-response))

마지막으로 적용되었던 Teaching Mode 의 parameter 값

enable 값은 언제나 true로 들어오며, 실제 teaching 적용 여부는 [`Get Teaching Area`](#get-teaching-area) 의 데이터 존재 여부로 판단

```json
{
  "type": "response",
  "request_id": "100",
  "status": "success",
  "data": {
    "action": "get_teaching_mode",
    "params": {
      "enable": true, // not use, allways true
      "range": 10.0, // [m]
      "margin": 10 // [m]
    }
  }
}
```

---

### Get Teaching Area ([`Request`](request.md#get-teaching-area-response))

현재 적용되어 있는 Teaching 영역의 좌표

데이터가 비어 있을 경우 teaching 이 설정되어 있지 않다고 판단

```json
{
  "type": "response",
  "request_id": "100",
  "status": "success",
  "data": {
    "action": "get_teaching_area",
    "params": {
      "area": [
        [
          { "x": 0.8425, "y": 0.7069, "z": -0.0205, "distance": 1.10 },
          ...
          { "x": 0.0763, "y": 0.0646, "z": -0.0019, "distance": 0.10 }
        ],
        [
          { "x": 0.8425, "y": 0.7069, "z": -0.0205, "distance": 1.10 },
          ...
          { "x": 0.0763, "y": 0.0646, "z": -0.0019, "distance": 0.10 }
        ],
        [
          { "x": 0.8425, "y": 0.7069, "z": -0.0205, "distance": 1.10 },
          ...
          { "x": 0.0763, "y": 0.0646, "z": -0.0019, "distance": 0.10 }
        ],

        [
          { "x": 0.8425, "y": 0.7069, "z": -0.0205, "distance": 1.10 },
          ...
          { "x": 0.0763, "y": 0.0646, "z": -0.0019, "distance": 0.10 }
        ],
      ]
    }
  }
}
```

---

### Get Motor Speed ([`Request`](request.md#get-motor-speed-response))

LiDAR 의 모터 스피드


```json
{
  "type": "response",
  "request_id": "100",
  "status": "success",
  "data": {
    "action": "get_motor_speed",
    "params": {
      "speed": 15
    }
  }
}
```

---

### Get Warning Area ([`Request`](request.md#get-warning-area-response))

현재 설정 된 경고 영역의 값

```json
{
  "type": "response",
  "request_id": "100",
  "status": "success",
  "data": {
    "action": "get_warning_area",
    "params": {
      "danger": 0.05,
      "warning": 0.15,
      "caution": 0.3
    }
  }
}
```

---

### Get Fog Filter ([`Request`](request.md#get-fog-filter-response))

현재 설정 된 Fog Filter 값

```json
{
  "type": "response",
  "request_id": "100",
  "status": "success",
  "data": {
    "action": "get_fog_filter",
    "params": {
      "level": 5,
      "disable_detection": false
    }
  }
}
```

---

### Get Radius Filter ([`Request`](request.md#get-radius-filter-response))

설정 된 오감지 필터 값

```json
{
  "type": "response",
  "request_id": "100",
  "status": "success",
  "data": {
    "action": "get_radius_filter",
    "params": {
      "level": 3
    }
  }
}
```

---

### Get Radius Filter Max Distance ([`Request`](request.md#get-radius-filter-max-distance-response))

현재 적용된 오감지 필터 최대 거리

```json
{
  "type": "response",
  "request_id": "100",
  "status": "success",
  "data": {
    "action": "get_radius_filter_max_distance",
    "params": {
      "distance": 10
    }
  }
}
```

---

### Get Radius Filter Min Distance ([`Request`](request.md#get-radius-filter-min-distance-response))

현재 적용된 오감지 필터 최소 거리

```json
{
  "type": "response",
  "request_id": "100",
  "status": "success",
  "data": {
    "action": "get_radius_filter_min_distance",
    "params": {
      "distance": 0
    }
  }
}
```

---

### Get Window Contamination Detection Mode ([`Request`](request.md#get-window-contamination-detection-mode-response))

현재 적용된 화면 오염 감지모드

```json
{
  "type": "response",
  "request_id": "100",
  "status": "success",
  "data": {
    "action": "get_window_contamination_detection_mode",
    "params": {
      "enable": false
    }
  }
}
```

---

### Get Network Source Info ([`Request`](request.md#get-network-source-info-response))

LiDAR 의 출발지 네트워크 정보

```json
{
  "type": "response",
  "request_id": "100",
  "status": "success",
  "data": {
    "action": "get_network_source_info",
    "params": {
      "ip": [192, 168, 123, 200],
      "mac": [0, 8, 220, 171, 205, 239],
      "subnet": [255, 255, 255, 0],
      "gateway": [192, 168, 123, 1],
      "port": 5000
    }
  }
}
```

---

### Get Network Destination Ip ([`Request`](request.md#get-network-destination-ip-response))

LiDAR 의 목적지 네트워크 정보

```json
{
  "type": "response",
  "request_id": "100",
  "status": "success",
  "data": {
    "action": "get_network_destination_ip",
    "params": {
      "ip": [192, 168, 123, 100]
    }
  }
}
```

---

### Get Network Info ([`Request`](request.md#get-network-info-response))

LiDAR 의 네트워크 정보

```json
{
  "type": "response",
  "request_id": "100",
  "status": "success",
  "data": {
    "action": "get_network_info",
    "params": {
      "src": {
        "ip": [192, 168, 123, 200],
        "mac": [ 0, 8, 220, 171, 205, 239],
        "subnet": [ 255, 255, 255, 0],
        "gateway": [ 192, 168, 123, 1],
        "port": 5000
      },
      "dst": {
        "ip": [ 192, 168, 123, 100]
      },
      "mode": {
        "mode": 0
      }
    }
  }
}
```

---

### Get Cloud Point Filter ([`Request`](request.md#get-cloud-point-filter))

LiDAR 포인트 필터 설정 조회

```json
{
  "type": "response",
  "request_id": "201",
  "status": "success",
  "data": {
    "action": "get_cloud_point_filter",
    "params": {
      "filter_type": "kalman",
      "history_count": 10,
      "min_distance": 0.2,
      "max_distance": 20.0,
      "q": 0.01,
      "r": 0.1,
      "threshold": 3.0
    }
  }
}
```

---

### Upload File ([`Request`](request.md#upload-file-response))

파일 업로드 완료 응답

```json
{
  "type": "response",
  "request_id": "201",
  "status": "success",
  "data": {
    "action": "upload_file",
    "params": {
      "filename": "firmware.bin",
      "file_size": 1024000,
      "content": "base64_encoded_file_content...",
      "sha256_checksum": "a1b2c3d4e5f6..."
    }
  }
}
```

---

### Download File ([`Request`](request.md#download-file-response))

파일 다운로드 응답

```json
{
  "type": "response",
  "request_id": "201",
  "status": "success",
  "data": {
    "action": "download_file",
    "params": {
      "filename": "firmware.bin",
      "file_size": 1024000,
      "content": "base64_encoded_file_content...",
      "sha256_checksum": "a1b2c3d4e5f6..."
    }
  }
}
```

---

### Get File List ([`Request`](request.md#get-file-list-response))

파일 목록 조회 응답

```json
{
  "type": "response",
  "request_id": "201",
  "status": "success",
  "data": {
    "action": "get_file_list",
    "params": [
      {
        "filename": "firmware.bin",
        "file_size": 1024000,
        "content": "",
        "sha256_checksum": "a1b2c3d4e5f6..."
      },
      {
        "filename": "config.json",
        "file_size": 512,
        "content": "",
        "sha256_checksum": "b2c3d4e5f6a1..."
      }
    ]
  }
}
```

---

### Firmware Update ([`Request`](request.md#firmware-update-response))

펌웨어 업데이트 완료 응답

```json
{
  "type": "response",
  "request_id": "201",
  "status": "success",
  "data": {
    "action": "firmware_update",
    "params": null
  }
}
```

---