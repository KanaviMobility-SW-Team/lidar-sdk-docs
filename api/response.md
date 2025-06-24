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
| [`DefaultResponse`](#default-response) | 기본 응답 |
| [`GetDeviceList`](#get-device-list-reqeust) | Device ID 목록 |
| [`GetBasicInfo`](#get-basic-info-reqeust) | 기본 설정 값 |
| [`GetVersionInfo`](#get-version-info-reqeust) | 버전 정보 |
| [`GetTeachingMode`](#get-teaching-mode-reqeust) | 티칭 모드 설정 값 |
| [`GetTeachingArea`](#get-teaching-area-reqeust) | 티칭 영역 좌표 |
| [`GetMotorSpeed`](#get-motor-speed-reqeust) | 모터 스피드 |
| [`GetWarningArea`](#get-warning-area-reqeust) | 경고 영역 |
| [`GetFogFilter`](#get-fog-filter-reqeust) | 안개 필터 |
| [`GetRadiusFilter`](#get-radius-filter-reqeust) | 오감지 필터 |
| [`GetRadiusFilterMaxDistance`](#get-radius-filter-max-distance-reqeust) | 오감지 필터 최대 거리 |
| [`GetRadiusFilterMinDistance`](#get-radius-filter-min-distance-reqeust) | 오감지 필터 최소 거리 |
| [`GetWindowContaminationDetectionMode`](#get-window-contamination-detection-mode-reqeust) | 스크린 오염 감지 설정 값 |
| [`GetNetworkSourceInfo`](#get-network-source-info-reqeust) | 네트워크 출발지 정보 |
| [`GetNetworkDestinationIp`](#get-network-destination-ip-reqeust) | 네트워크 목적지 IP |
| [`GetNetworkInfo`](#get-network-info-reqeust) | 네트워크 정보 |

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

### Get Device List ([`Reqeust`](request.md#get-device-list-response))

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

### Get Basic Info ([`Reqeust`](request.md#get-basic-info-response))

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

### Get Version Info ([`Reqeust`](request.md#get-version-info-response))

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

### Get Teaching Mode ([`Reqeust`](request.md#get-teaching-mode-response))

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

### Get Teaching Area ([`Reqeust`](request.md#get-teaching-area-response))

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
          {
            "x": 0.84250194,
            "y": 0.70694315,
            "z": -0.020541335
          },
          {
            "x": 0.076309934,
            "y": 0.06460113,
            "z": -0.001867394
          },
          ...
          {
            "x": -66.14379,
            "y": 56.49213,
            "z": -1.6246328
          },
          {
            "x": -72.494446,
            "y": 61.371075,
            "z": -1.7740244
          }
        ],
        [
          {
            "x": 73.61687,
            "y": 61.771893,
            "z": 0
          },
          {
            "x": 0.07632324,
            "y": 0.064612396,
            "z": 0
          },
          ...
          {
            "x": -66.162926,
            "y": 56.508472,
            "z": 0
          },
          {
            "x": -5.35026,
            "y": 4.529329,
            "z": 0
          }
        ],
        [
          {
            "x": 4.672056,
            "y": 3.920321,
            "z": 0.11391104
          },
          {
            "x": 0.076309934,
            "y": 0.06460113,
            "z": 0.001867394
          },
          ...
          {
            "x": -64.623245,
            "y": 55.193462,
            "z": 1.587285
          },
          {
            "x": -74.02064,
            "y": 62.663094,
            "z": 1.8113723
          }
        ],
        [
          {
            "x": 75.86206,
            "y": 63.655834,
            "z": 3.7005296
          },
          {
            "x": 0.076270014,
            "y": 0.064567335,
            "z": 0.0037341365
          },
          ...
          {
            "x": -61.549927,
            "y": 52.5686,
            "z": 3.0246508
          },
          {
            "x": -67.117615,
            "y": 56.819252,
            "z": 3.2860405
          }
        ]
      ]
    }
  }
}
```

---

### Get Motor Speed ([`Reqeust`](request.md#get-motor-speed-response))

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

### Get Warning Area ([`Reqeust`](request.md#get-warning-area-response))

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

### Get Fog Filter ([`Reqeust`](request.md#get-fog-filter-response))

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

### Get Radius Filter ([`Reqeust`](request.md#get-radius-filter-response))

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

### Get Radius Filter Max Distance ([`Reqeust`](request.md#get-radius-filter-max-distance-response))

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

### Get Radius Filter Min Distance ([`Reqeust`](request.md#get-radius-filter-min-distance-response))

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

### Get Window Contamination Detection Mode ([`Reqeust`](request.md#get-window-contamination-detection-mode-response))

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

### Get Network Source Info ([`Reqeust`](request.md#get-network-source-info-response))

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

### Get Network Destination Ip ([`Reqeust`](request.md#get-network-destination-ip-response))

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

### Get Network Info ([`Reqeust`](request.md#get-network-info-response))

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

