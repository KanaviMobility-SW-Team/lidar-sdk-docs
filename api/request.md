# Request Message

## Request 형식

| 필드 | 타입 | 설명 |
| - | - | - |
| `request_id` | `string`| 요청 식별자 (client에서 지정) |
| `device_id` | [`Device ID`](#device-id) \| `null` | 대상 장치 ID (선택사항) |
| `data` | [`Request Data`](#request-data) | 요청 데이터 (action, params) |

---

## Device ID

| 필드 | 타입 | 설명 |
| - | - | - |
| `ip` | `integer` | LiDAR의 4바이트 IPv4 주소를 정수로 변환한 값 (예: 192.168.0.1 → 0xC0A80001) |
| `port`| `integer` | LiDAR Port |
| `model` | `integer` | LiDAR Model (3: R2, 6: R4, 7: R270)|
| `id` | `integer` | LiDAR ID |

---

## Request Data

| 필드 | 타입 | 설명 |
| - | - | - |
| `action` | [`Action`](#actions--params) | 클라이언트가 서버에 요청하고자 하는 동작의 종류 |
| `params` | [`Param`](#actions--params) \| `null` | action 수행에 필요한 추가 매개변수 (선택사항) |

---

## Actions & Params

|Actions|Params|설명|
|-|-|-|
|[`get_device_list`](#get-device-list)|`port`|`port`로 연결 된 LiDAR 목록
|[`subscribe_devices`](#subscribe-devices)|`List<device_id>`|스캔 좌표 데이터 수신을 위한 설정
|[`reset_config`](#reset-config)|`null`|설정 초기화 (네트워크, ID등 초기화되지 않는 정보도 있음)
|[`get_basic_info`](#get-basic-info)|`null`|기본 설정 값 조회
|[`set_h_fov`](#set-horizontal-field-of-view)|`start_angle`, `end_angle`|수평 각도 설정
|[`set_output_channel`](#set-output-channel)|`channel`|채널 활성화 설정
|[`set_user_area`](#set-user-area)|`List<area>`|사용자 영역 설정
|[`set_object_size`](#set-object-size)|`size`|감지 물체 크기 설정
|[`set_detection_hold_time`](#set-detection-hold-time)|`time`|감지 영역에 머문 물체를 감지로 판단하는 시간 설정
|[`get_version_info`](#get-version-info)|`null`|버전 정보 조회
|[`set_distance_range`](#set-distance-range)|`start_distance`, `end_distance`|스캔 거리 설정
|[`set_pulse_active_state`](#set-pulse-active-state)|`active`|감지 활성화 핀 상태 설정
|[`set_pulse_pin_mode`](#set-pulse-pin-mode)|`mode`, `channel`|펄스 핀 모드 설정
|[`set_self_check_active_state`](#set-self-check-active-state)|`active`|자체 점검 핀 상태 설정
|[`set_teaching_mode`](#set-teaching-mode)|`enable`, `range`, `margin`|티칭 모드 설정
|[`get_teaching_mode`](#get-teaching-mode)|`null`|티칭 모드 조회
|[`get_teaching_area`](#get-teaching-area)|`null`|티칭 영역 조회
|[`set_guide_beam`](#set-guide-beam)|`enable`|가이드 빔 설정
|[`set_id`](#set-id)|`id`|ID 값 설정
|[`set_motor_speed`](#set-motor-speed)|`speed`|모터 속도 설정
|[`get_motor_speed`](#get-motor-speed)|`null`|모터 속도 조회
|[`set_warning_area`](#set-warning-area)|`danger`, `warning`, `caution`|경고 영역 설정
|[`get_warning_area`](#get-warning-area)|`null`|경고 영역 조회
|[`set_fog_filter`](#set-fog-filter)|`level`, `disable_detection`|안개 필터 설정
|[`get_fog_filter`](#get-fog-filter)|`null`|안개 필터 조회
|[`set_radius_filter`](#set-radius-filter)|`level`|오감지 필터 설정
|[`get_radius_filter`](#get-radius-filter)|`null`|오감지 필터 조회
|[`set_radius_filter_max_distance`](#set-radius-filter-max-distance)|`distance`|오감지 필터 최대 거리 설정
|[`get_radius_filter_max_distance`](#get-radius-filter-max-distance)|`null`|오감지 필터 최대 거리 조회
|[`set_radius_filter_min_distance`](#set-radius-filter-min-distance)|`distance`|오감지 필터 최소 거리 설정
|[`get_radius_filter_min_distance`](#get-radius-filter-min-distance)|`null`|오감지 필터 최소 거리 조회
|[`set_window_contamination_detection_mode`](#set-window-contamination-detection-mode)|`mode`|스크린 오염 감지 설정
|[`get_window_contamination_detection_mode`](#get-window-contamination-detection-mode)|`null`|스크린 오염 감지 조회
|[`set_network_source_info`](#set-network-source-info)|`ip`, `mac`, `subnet`, `gateway`, `port`|LiDAR 출발지 네트워크 값 설정
|[`get_network_source_info`](#get-network-source-info)|`null`|LiDAR 출발지 네트워크 값 조회
|[`set_ethernet_mode`](#set-ethernet-mode)|`mode`|이더넷 모드 설정
|[`set_network_destination_ip`](#set-network-destination-ip)|`ip`|LiDAR 목적지 IP 설정
|[`get_network_destination_ip`](#get-network-destination-ip)|`null`|LiDAR 목적지 IP 조회
|[`set_network_info`](#set-network-info)|`src`, `dst`, `mode`|LiDAR 네트워크 정보 설정
|[`get_network_info`](#get-network-info)|`null`|LiDAR 네트워크 정보 조회

---

### Get Device List

`port`로 소켓을 열고 들어오는 LiDAR UDP Packet 확인하여 그 목록을 반환

```json
{
  "type": "request",
  "request_id": "1",
  "device_id": null,
  "data": {
    "action": "get_device_list",
    "params": {
      "port": 5000
    }
  }
}
```

---

### Subscribe Devices

LiDAR 스캔 좌표 데이터를 실시간으로 구독, 여러개의 LiDAR 데이터를 받아 오고 싶을 경우 배열에 여러개의 Device ID 를 포함 시키면 가능

```json
{
  "type": "request",
  "request_id": "1",
  "device_id": null,
  "data": {
    "action": "subscribe_devices",
    "params": [
        {
            "ip":3232267208,
            "port":5000,
            "model":6,
            "id":208
        }
    ]
  }
}
```

구독을 해제하고 싶을 경우 빈 배열을 전달하여 초기화 가능

```json
{
  "type": "request",
  "request_id": "1",
  "device_id": null,
  "data": {
    "action": "subscribe_devices",
    "params": []
  }
}
```

---

### Reset Config

LiDAR 의 모든 설정을 초기화. 단, Network Info, ID, Motor Speed 값은 초기화되지 않음

```json
{
  "type": "request",
  "request_id": "1",
  "device_id": {
    "ip":3232267208,
    "port":5000,
    "model":6,
    "id":208
  },
  "data": {
    "action": "reset_config",
    "params": null
  }
}
```

---

### Get Basic Info

LiDAR 의 기본 설정값을 조회. 대부분의 설정 값이 조회 되나, 안개 필터, 오감지 필터 등은 별도의 조회 명령 필요

```json
{
  "type": "request",
  "request_id": "1",
  "device_id": {
    "ip":3232267208,
    "port":5000,
    "model":6,
    "id":208
  },
  "data": {
    "action": "get_basic_info",
    "params": null
  }
}
```

---

### Set Horizontal Field Of View

LiDAR 수평 시야각 설정

|제품|수평 시야각|
|-|-|
|R2|120|
|R4|100|
|R270|270|

설정 값은 각 제품별 최대 시야각을 넘지 않도록 설정

```json
{
  "type": "request",
  "request_id": "1",
  "device_id": {
    "ip":3232267208,
    "port":5000,
    "model":6,
    "id":208
  },
  "data": {
    "action": "set_h_fov",
    "params": {
      // [°]
      "start_angle": 5, 
      "end_angle": 95
    }
  }
}
```

---

### Set Output Channel

출력 채널을 별도로 설정 가능

모든 채널 비활성화 불가능 (R270의 경우 해당 명령 지원하지 않음)

|제품|채널 수|채널 간 각도(VFov Resol)|
|-|-|-|
|R2|2|3
|R4|4|1.07
|R270|1|-

```json
{
  "type": "request",
  "request_id": "1",
  "device_id": {
    "ip":3232267208,
    "port":5000,
    "model":6,
    "id":208
  },
  "data": {
    "action": "set_output_channel",
    "params": {
      "channel": [
        true, 
        false, 
        true, 
        false
      ]
    }
  }
}
```

---

### Set User Area

사용자 기반(좌표) 감지 영역 설정. 좌표는 최소 3개 이상으로 영역이 구성 될 수 있는 조건 성립 필요

사용자 영역은 평면 기준으로 작동하므로 Z 좌표 값은 0으로 설정

1개의 영역 당 최대 좌표 수는 20개이며, 최대 영역의 수는 기본적으로 5개 (Pulse Pin Mode 에 따라 달라 질 수 있음)

```json
{
  "type": "request",
  "request_id": "1",
  "device_id": {
    "ip":3232267208,
    "port":5000,
    "model":6,
    "id":208
  },
  "data": {
    "action": "set_user_area",
    "params": [
      {
        "area": [
          {"x": 0.0, "y": 0.03, "z": 0.0},
          {"x": -3.34, "y": 3.37, "z": 0.0},
          {"x": -2.25, "y": 4.45, "z": 0.0},
          {"x": 1.08, "y": 1.11, "z": 0.0}
        ]
      }
    ]
  }
}
```

---

### Set Object Size

감지 영역 안의 감지할 물체의 최소 크기 설정

벌레, 눈, 비 등의 오탐을 피하고자 할 경우 최소 크기를 크게 설정

```json
{
  "type": "request",
  "request_id": "1",
  "device_id": {
    "ip":3232267208,
    "port":5000,
    "model":6,
    "id":208
  },
  "data": {
    "action": "set_object_size",
    "params": {
      "size": 10 // [cm], 0 to 255, step 1
    }
  }
}
```

---

### Set Detection Hold Time

물체가 일정 시간 이상 감지 영역에 머물 때 감지로 판단하는 설정

벌레, 눈, 비 등은 빠르게 지나가므로 해당 설정값을 크게 설정 할 경우 오탐 하지 않음

```json
{
  "type": "request",
  "request_id": "1",
  "device_id": {
    "ip":3232267208,
    "port":5000,
    "model":6,
    "id":208
  },
  "data": {
    "action": "set_detection_hold_time",
    "params": {
      "time": 100 // [ms], 0 - 1000, step 100
    }
  }
}
```

---

### Get Version Info

LiDAR Firmware, Hardware 버전과 사용처에 대한 정보를 조회

```json
{
  "type": "request",
  "request_id": "1",
  "device_id": {
    "ip":3232267208,
    "port":5000,
    "model":6,
    "id":208
  },
  "data": {
    "action": "get_version_info",
    "params": null
  }
}
```

---

### Set Distance Range

LiDAR Scan 최소, 최대 거리를 지정

해당 Range 에 포함되지 않는 Scan 데이터는 표시 및 감지되지 않음

|제품|최대 거리 [m]|
|-|-|
|R2|70|
|R4|50|
|R270|30|

설정 값은 각 제품별 최대 거리를 넘지 않도록 설정

```json
{
  "type": "request",
  "request_id": "1",
  "device_id": {
    "ip":3232267208,
    "port":5000,
    "model":6,
    "id":208
  },
  "data": {
    "action": "set_distance_range",
    "params": {
      // [m]
      "start_distance":0, 
      "end_distance": 10
    }
  }
}
```

---

### Set Pulse Active State

감지가 활성화 상태의 출력 핀 상태 설정

|값|Active|Trigger|
|-|-|-|
|`true`|High|Low|
|`false`|Low|High|

```json
{
  "type": "request",
  "request_id": "1",
  "device_id": {
    "ip":3232267208,
    "port":5000,
    "model":6,
    "id":208
  },
  "data": {
    "action": "set_pulse_active_state",
    "params": {
      "active":true 
    }
  }
}
```

---

### Set Pulse Pin Mode

출력 핀을 설정값을 커스텀 하게 사용할 수 있는 설정 값

각 제품 별 다른 설정 값을 가지고 있음

**R2**

|mode|channel|설명|
|-|-|-|
|0|0x03|어떠한 채널의 데이터라도 감지 영역에 감지 되었을 경우 모든 출력 핀 활성화|
|1|0x03|2 채널 모두 감지 영역에 감지 되었을 시 핀이 활성화|
|2|0xC3|최대 2개의 사용자 영역 생성 가능하며, n번째 영역 감지 -> n번 출력 핀 활성화

**R4**

|mode|channel|설명|
|-|-|-|
|0|0x0F|어떠한 채널의 데이터라도 감지 영역에 감지 되었을 경우 모든 출력 핀 활성화|
|1|0x03|1, 2 채널 모두 감지 영역에 감지 되었을 시 핀이 활성화|
|1|0x05|1, 3 채널 모두 감지 영역에 감지 되었을 시 핀이 활성화|
|1|0x09|1, 4 채널 모두 감지 영역에 감지 되었을 시 핀이 활성화|
|1|0x06|2, 3 채널 모두 감지 영역에 감지 되었을 시 핀이 활성화|
|1|0x0A|2, 4 채널 모두 감지 영역에 감지 되었을 시 핀이 활성화|
|1|0x0C|3, 4 채널 모두 감지 영역에 감지 되었을 시 핀이 활성화|
|2|0xC3|최대 4개의 사용자 영역 생성 가능하며, n번째 영역 -> n 번째 채널의 데이터에서만 동작 (채널별 감지영역 1개), 출력 핀의 경우 mode 0과 동일 하게 4개의 사용자 영역 중 1개라도 감지 될 경우 모든 출력 핀 활성화

**R270**
|mode|channel|설명|
|-|-|-|
|0|0x01|감지 영역에 감지 되었을 경우 모든 출력 핀 활성화|
|1|0x00|최대 3개의 사용자 영역 생성 가능하며, n번째 영역 감지 -> n번 출력 핀 활성화|

```json
{
  "type": "request",
  "request_id": "1",
  "device_id": {
    "ip":3232267208,
    "port":5000,
    "model":6,
    "id":208
  },
  "data": {
    "action": "set_pulse_pin_mode",
    "params": {
      "mode":1, 
      "channel":3
    }
  }
}
```

---

### Set Self Check Active State

LiDAR 는 자기 점검 기능을 가지고 있으며, 제품에 문제가 있을 경우 Self Check Pin 신호를 활성화 시킴

위 Self Check Pin 신호 활성화 상태의 출력 핀 상태 설정

|값|Active|Trigger|
|-|-|-|
|`true`|High|Low|
|`false`|Low|High|

```json
{
  "type": "request",
  "request_id": "1",
  "device_id": {
    "ip":3232267208,
    "port":5000,
    "model":6,
    "id":208
  },
  "data": {
    "action": "set_self_check_active_state",
    "params": {
      "active":true 
    }
  }
}
```

---

### Set Teaching Mode

현재 표시되고 있는 스캔 좌표 기반으로 자동 영역 설정 진행

각 영역은 채널 별 1개가 생성되며, Teaching 으로 그려진 영역은 수정 불가

range: 자동 영역의 최대 거리

margin: 자동 영역과 스캔 좌표 사이의 간격

```json
{
  "type": "request",
  "request_id": "1",
  "device_id": {
    "ip":3232267208,
    "port":5000,
    "model":6,
    "id":208
  },
  "data": {
    "action": "set_teaching_mode",
    "params": {
      "enable": true, 
      "range": 10.0, // [m], 0 - 20.9, step 0.1
      "margin": 10 // [%], 0 - 50, step 1
    }
  }
}
```

---

### Get Teaching Mode

마지막으로 적용되었던 Teaching Mode 의 parameter 값 조회

```json
{
  "type": "request",
  "request_id": "1",
  "device_id": {
    "ip":3232267208,
    "port":5000,
    "model":6,
    "id":208
  },
  "data": {
    "action": "get_teaching_mode",
    "params": null
  }
}
```

---

### Get Teaching Area

현재 적용되어 있는 Teaching 영역의 좌표 조회

```json
{
  "type": "request",
  "request_id": "1",
  "device_id": {
    "ip":3232267208,
    "port":5000,
    "model":6,
    "id":208
  },
  "data": {
    "action": "get_teaching_area",
    "params": null
  }
}
```

---

### Set Guide Beam

LiDAR 설치 등에 필요한 육안으로 볼 수 있는 빔 설정

설정 시 3분간 작동하며, R4 만 지원

```json
{
  "type": "request",
  "request_id": "1",
  "device_id": {
    "ip":3232267208,
    "port":5000,
    "model":6,
    "id":208
  },
  "data": {
    "action": "set_guide_beam",
    "params": {
      "enable": true
    }
  }
}
```

---

### Set ID

LiDAR 식별자 중 하나인 ID 값 변경

설정한 ID 값에 0xD0을 더한 값이 LiDAR에 저장됨

ID 는 식별자인 Device ID 값이므로, 변경 후 재접속 필요

```json
{
  "type": "request",
  "request_id": "1",
  "device_id": {
    "ip":3232267208,
    "port":5000,
    "model":6,
    "id":208
  },
  "data": {
    "action": "set_id",
    "params": {
      "id": 5 // 0 - 15, step 1, 5 설정 시 실제 LiDAR 에 저장 되는 값은 0xD5
    }
  }
}
```

---

### Set Motor Speed

LiDAR의 모터 스피드 설정, R270 만 지원

```json
{
  "type": "request",
  "request_id": "1",
  "device_id": {
    "ip":3232267208,
    "port":5000,
    "model":6,
    "id":208
  },
  "data": {
    "action": "set_motor_speed",
    "params": {
      "speed": 15 // 15 - 25, step 5
    }
  }
}
```

---

### Get Motor Speed

LiDAR 의 모터 스피드 조회, R270 만 지원

```json
{
  "type": "request",
  "request_id": "1",
  "device_id": {
    "ip":3232267208,
    "port":5000,
    "model":6,
    "id":208
  },
  "data": {
    "action": "get_motor_speed",
    "params": null
  }
}
```

---

### Set Warning Area

위험, 경고, 주의 3단계의 영역 설정, R270 만 지원

각 영역은 원 형태로 구성되며, 설정은 반지름 값으로 설정

위험 영역은 경고 영역보다 클 수 없으며, 경고 영역은 주의 영역보다 클 수 없음

각 영역은 출력 핀과 연동 됨 (danger = output 1, warning = output 2, caution = output 3)

```json
{
  "type": "request",
  "request_id": "1",
  "device_id": {
    "ip":3232267208,
    "port":5000,
    "model":6,
    "id":208
  },
  "data": {
    "action": "set_warning_area",
    "params": {
      // [m], 0 - 30.00, step 0.01
      "danger": 0.05,
      "warning":0.15, 
      "caution": 0.30
    }
  }
}
```

---

### Get Warning Area

현재 설정 된 경고 영역의 값 조회, R270 만 지원

```json
{
  "type": "request",
  "request_id": "1",
  "device_id": {
    "ip":3232267208,
    "port":5000,
    "model":6,
    "id":208
  },
  "data": {
    "action": "get_warning_area",
    "params": null
  }
}
```

---

### Set Fog Filter

안개 필터 설정, R4 만 지원

심한 안개의 경우 오탐을 할 가능성이 있어, 심한 안개 감지 시 영역 감지를 하지 않는 옵션(detection_disable) 존재

```json
{
  "type": "request",
  "request_id": "1",
  "device_id": {
    "ip":3232267208,
    "port":5000,
    "model":6,
    "id":208
  },
  "data": {
    "action": "set_fog_filter",
    "params": {
      "level": 5, // 0 - 5, step 1
      "disable_detection": true
    }
  }
}
```

---

### Get Fog Filter

현재 설정 된 Fog Filter 값 조회, R4 만 지원

```json
{
  "type": "request",
  "request_id": "1",
  "device_id": {
    "ip":3232267208,
    "port":5000,
    "model":6,
    "id":208
  },
  "data": {
    "action": "get_fog_filter",
    "params": null
  }
}
```

---

### Set Radius Filter

오감지 필터 설정, R4 만 지원

```json
{
  "type": "request",
  "request_id": "1",
  "device_id": {
    "ip":3232267208,
    "port":5000,
    "model":6,
    "id":208
  },
  "data": {
    "action": "set_radius_filter",
    "params": {
      "level": 2 // 0 - 3, step 1
    }
  }
}
```

---

### Get Radius Filter

설정 된 오감지 필터 값 조회, R4 만 지원

```json
{
  "type": "request",
  "request_id": "1",
  "device_id": {
    "ip":3232267208,
    "port":5000,
    "model":6,
    "id":208
  },
  "data": {
    "action": "get_radius_filter",
    "params": null
  }
}
```

### Set Radius Filter Max Distance

오감지 필터를 적용 할 최대 거리 설정, R4 만 지원

```json
{
  "type": "request",
  "request_id": "1",
  "device_id": {
    "ip":3232267208,
    "port":5000,
    "model":6,
    "id":208
  },
  "data": {
    "action": "set_radius_filter_max_distance",
    "params": {
      "distance": 10 // [m], 1 - 10, step 1
    }
  }
}
```

---

### Get Radius Filter Max Distance

현재 적용된 오감지 필터 최대 거리 조회, R4 만 지원

```json
{
  "type": "request",
  "request_id": "1",
  "device_id": {
    "ip":3232267208,
    "port":5000,
    "model":6,
    "id":208
  },
  "data": {
    "action": "get_radius_filter_max_distance",
    "params": null
  }
}
```

---

### Set Radius Filter Min Distance

오감지 필터를 적용 할 최소 거리 설정, R4 만 지원

```json
{
  "type": "request",
  "request_id": "1",
  "device_id": {
    "ip":3232267208,
    "port":5000,
    "model":6,
    "id":208
  },
  "data": {
    "action": "set_radius_filter_min_distance",
    "params": {
      "distance": 10 // [cm], 0 - 100, step 10
    }
  }
}
```

---

### Get Radius Filter Min Distance

현재 적용된 오감지 필터 최소 거리 조회, R4 만 지원

```json
{
  "type": "request",
  "request_id": "1",
  "device_id": {
    "ip":3232267208,
    "port":5000,
    "model":6,
    "id":208
  },
  "data": {
    "action": "get_radius_filter_min_distance",
    "params": null
  }
}
```

---

### Set Window Contamination Detection Mode

LiDAR 화면 오염 감지 모드 설정, R4 만 지원

감지를 할 수 없을 정도로 LiDAR 화면이 오염 된 경우 Self Check Pin을 활성화 하여 오염을 알림

```json
{
  "type": "request",
  "request_id": "1",
  "device_id": {
    "ip":3232267208,
    "port":5000,
    "model":6,
    "id":208
  },
  "data": {
    "action": "set_window_contamination_detection_mode",
    "params": {
      "mode": true
    }
  }
}
```

---

### Get Window Contamination Detection Mode

현재 적용된 화면 오염 감지모드 조회, R4 만 지원

```json
{
  "type": "request",
  "request_id": "1",
  "device_id": {
    "ip":3232267208,
    "port":5000,
    "model":6,
    "id":208
  },
  "data": {
    "action": "get_window_contamination_detection_mode",
    "params": null
  }
}
```

---

### Set Network Source Info

LiDAR 의 출발지 네트워크 정보 설정

```json
{
  "type": "request",
  "request_id": "1",
  "device_id": {
    "ip":3232267208,
    "port":5000,
    "model":6,
    "id":208
  },
  "data": {
    "action": "set_network_source_info",
    "params": {  
      "ip":[192,168,123,200], 
      "mac":[0, 8, 205, 171, 205, 239], 
      "subnet":[255,255,255,0], 
      "gateway": [192,168,123,1], 
      "port": 5000
    }
  }
}
```

---

### Get Network Source Info

LiDAR 의 출발지 네트워크 정보 조회

```json
{
  "type": "request",
  "request_id": "1",
  "device_id": {
    "ip":3232267208,
    "port":5000,
    "model":6,
    "id":208
  },
  "data": {
    "action": "get_network_source_info",
    "params": null
  }
}
```

---

### Set Ethernet Mode

LiDAR 의 네트워크 모드 설정

LiDAR 네트워크 모드의 경우 Get을 제공 하지 않음

|mode|설명|
|-|-|
|0|멀티캐스트|
|1|유니캐스트|

```json
{
  "type": "request",
  "request_id": "1",
  "device_id": {
    "ip":3232267208,
    "port":5000,
    "model":6,
    "id":208
  },
  "data": {
    "action": "set_ethernet_mode",
    "params": {
      "mode": 0
    }
  }
}
```

---

### Set Network Destination IP

LiDAR 의 네트워크 목적지 IP 설정

```json
{
  "type": "request",
  "request_id": "1",
  "device_id": {
    "ip":3232267208,
    "port":5000,
    "model":6,
    "id":208
  },
  "data": {
    "action": "set_network_destination_ip",
    "params": {
      "ip": [192,168,123,100]
    }
  }
}
```

---

### Get Network Destination IP

LiDAR 의 네트워크 정보 조회

ethernet mode 의 경우 정보를 제공하지 않음

```json
{
  "type": "request",
  "request_id": "1",
  "device_id": {
    "ip":3232267208,
    "port":5000,
    "model":6,
    "id":208
  },
  "data": {
    "action": "get_network_destination_ip",
    "params": null
  }
}
```

---

### Set Network Info

LiDAR 의 네트워크 정보 설정

위 Source, Destination, Ethernet Mode 값을 한번에 설정

설정 시 자동 재부팅 진행

특별한 이유가 없을 경우 해당 API 이용 권장 (자동 재부팅 등 즉시 적용)

```json
{
  "type": "request",
  "request_id": "1",
  "device_id": {
    "ip":3232267208,
    "port":5000,
    "model":6,
    "id":208
  },
  "data": {
    "action": "set_network_info",
    "params": {
      "src": {
        "ip":[192,168,123,200], 
        "mac":[0, 8, 205, 171, 205, 239], 
        "subnet":[255,255,255,0], 
        "gateway": [192,168,123,1], 
        "port": 5000
      },
      "dst": {
        "ip": [192,168,123,100]
      },
      "mode": {
        "mode": 0 // 0: multicast mode, 1: unicast mode
      }
    }
  }
}
```

---

### Get Network Info

LiDAR 의 네트워크 정보 조회

ethernet mode 의 경우 정보를 제공하지 않음

```json
{
  "type": "request",
  "request_id": "1",
  "device_id": {
    "ip":3232267208,
    "port":5000,
    "model":6,
    "id":208
  },
  "data": {
    "action": "get_network_info",
    "params": null
  }
}
```

---