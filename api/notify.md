# Notify Message

## Notify 형식

| 필드 | 타입 | 설명 |
| - | - | - |
| `device_id` | [`Device ID`](request.md#device-id) | LiDAR 장치 ID |
| `data` | [`NotifyData`](#notify-data) | 채널 및 좌표 데이터 |

---

## Notify Data

| 필드 | 타입 | 설명 |
| - | - | - |
| `action` | [`Action`](#scan-result) | scan_result |
| `params` | [`Param`](#scan-result) | 채널 및 좌표 데이터 |

---

### Scan Result

거리 데이터를 좌표로 변환한 데이터

채널별로 데이터가 나눠져서 송신

클라이언트에서 Subscribe Request 송신 시 실시간으로 메시지가 전달

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
        {
          "x": 0.2828427,
          "y": -0.2828427,
          "z": 0
        },
        {
          "x": 0.2769723,
          "y": -0.27456573,
          "z": 0
        },
		    ...
        {
          "x": -3.8515515,
          "y": -3.7849107,
          "z": 0
        },
        {
          "x": -3.8634076,
          "y": -3.829841,
          "z": 0
        }
      ]
    }
  }
}
```

---