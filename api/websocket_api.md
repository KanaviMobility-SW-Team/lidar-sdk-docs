# WebSocket API 메시지 형식

WebSocket 메시지는 JSON 형식으로 전송하며, `type` 필드로 메시지 종류를 구분합니다.

---

## Websocket Address

기본 포트는 5555를 사용하며, 5555포트가 사용중 일 경우 5655 까지 1씩 포트 번호를 증가 하여 포트 사용 여부 확인 후 실행


```
ws://10.10.10.254:5555
```

---

## Message 구조

### Base Message

```json
{
  "type": "<message_type>",
  ...
}
```

| message_type | 설명 |
| - | - |
| [`request`](request.md) | 요청 메시지 |
| [`response`](response.md) | 응답 메시지 |
| [`notify`](notify.md) | LiDAR 좌표 메시지 |
| [`error`](error.md) | 오류 메시지 |

---

## Message Flow

### Set 요청

모든 Set 요청은 [`default_response`](response.md#default-response) 를 반환

|요청|응답|
|-|-|
|모든 `set_*/reset_*/subscribe_*` action|[`default_response`](response.md#default-response)|

---

### Get 요청

|요청|응답|
|-|-|
|[`get_device_list`](request.md#get-device-list)|[`get_device_list`](response.md#get-device-list)|
|[`get_basic_info`](request.md#get-basic-info)|[`get_basic_info`](response.md#get-basic-info)|
|[`get_version_info`](request.md#get-version-info)|[`get_version_info`](response.md#get-version-info)|
|[`get_teaching_mode`](request.md#get-teaching-mode)|[`get_teaching_mode`](response.md#get-teaching-mode)|
|[`get_teaching_area`](request.md#get-teaching-area)|[`get_teaching_area`](response.md#get-teaching-area)|
|[`get_motor_speed`](request.md#get-motor-speed)|[`get_motor_speed`](response.md#get-motor-speed)|
|[`get_warning_area`](request.md#get-warning-area)|[`get_warning_area`](response.md#get-warning-area)|
|[`get_fog_filter`](request.md#get-fog-filter)|[`get_fog_filter`](response.md#get-fog-filter)|
|[`get_radius_filter`](request.md#get-radius-filter)|[`get_radius_filter`](response.md#get-radius-filter)|
|[`get_radius_filter_max_distance`](request.md#get-radius-filter-max-distance)|[`get_radius_filter_max_distance`](response.md#get-radius-filter-max-distance)|
|[`get_radius_filter_min_distance`](request.md#get-radius-filter-min-distance)|[`get_radius_filter_min_distance`](response.md#get-radius-filter-min-distance)|
|[`get_window_contamination_detection_mode`](request.md#get-window-contamination-detection-mode)|[`get_window_contamination_detection_mode`](response.md#get-window-contamination-detection-mode)|
|[`get_network_source_info`](request.md#get-network-source-info)|[`get_network_source_info`](response.md#get-network-source-info)|
|[`get_network_destination_ip`](request.md#get-network-destination-ip)|[`get_network_destination_ip`](response.md#get-network-destination-ip)|
|[`get_network_info`](request.md#get-network-info)|[`get_network_info`](response.md#get-network-info)|

---

### 실시간 알림

LiDAR 스캔 데이터를 실시간으로 알림

|요청|응답|
|-|-|
|**자동 통지** (subscribe_devices 설정 후)|[`scan_result`](notify.md#scan-result)|

---