# Notify Message

## Notify 형식

| 필드 | 타입 | 설명 |
| - | - | - |
| `device_id` | [`Device ID`](request.md#device-id) | LiDAR 장치 ID |
| `data` | [`NotifyData`](#notify-data) | 알림 데이터 (스캔/감지) |

---

## Notify Data

| 필드 | 타입 | 설명 |
| - | - | - |
| `action` | [`Action`](#actions) | 알림 종류 |
| `params` | `Param` | 알림 데이터 |

### Actions

- `scan_result` → 스캔 포인트 클라우드
- `detection_result` → 출력핀/영역 감지 결과

---

### Scan Result

거리 데이터를 좌표로 변환한 데이터. 채널별로 송신. `subscribe_devices` 설정 후 실시간으로 전달.

```json
{
  "type": "notify",
  "device_id": {
    "ip": 3232267208,
    "port": 5000,
    "model": 7,
    "id": 208
  },
  "data": {
    "action": "scan_result",
    "params": {
      "channel": 0,
      "points": [
        { "x": 0.2828427, "y": -0.2828427, "z": 0, "distance": 0.40 },
        { "x": 0.2769723, "y": -0.27456573, "z": 0, "distance": 0.39 }
      ]
    }
  }
}
```

- `points[].distance`: 원거리(m)

---

### Detection Result

감지 결과 비트맵. 클라이언트 구독 중 해당 장치 상태 업데이트 시 전송.

```json
{
  "type": "notify",
  "device_id": {
    "ip": 3232267208,
    "port": 5000,
    "model": 6,
    "id": 208
  },
  "data": {
    "action": "detection_result",
    "params": {
      "output_pin": [0, 1, 0],
      "area_detect": [0, 0, 1, 0]
    }
  }
}
```

---