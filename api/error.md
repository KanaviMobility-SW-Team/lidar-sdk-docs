# Error Message

## Error 형식

| 필드 | 타입 | 설명 |
| - | - | - |
| `request_id` | `string`| 요청 식별자 (client에서 지정) |
| `code` | `integer` | 에러 코드 |
| `message` | `string` | 에러 메시지 |

---

## Error Code

|Code|Message|
|-|-|
|`100`|[`InvalidDataFormat`](#invalid-data-format)|
|`101`|[`InvalidRequest`](#invalid-request)|
|`102`|[`InvalidRequestDeviceIDNotFound`](#invalid-request-device-id-not-found)|
|`103`|[`Timeout`](#timeout)|


---

### Invalid Data Format

유효하지 않은 json 포맷의 request 시 발생 (JSON parsing 오류)

```json
{
  "type": "error",
  "request_id": "100",
  "code": 100,
  "message": "Invalid data format"
}
```

---

### Invalid Request

유효하지 않은 request 시 발생 (action 명칭 등 철자 오류 시 주로 발생)

```json
{
  "type": "error",
  "request_id": "100",
  "code": 101,
  "message": "Invalid request type"
}
```

---

### Invalid Request Device ID Not Found

유효하지 않은 Device ID 로부터 request 시 발생

```json
{
  "type": "error",
  "request_id": "100",
  "code": 102,
  "message": "Invalid request type, device ID not found"
}
```

---

### Timeout

request 요청이 일정 시간동안 처리되지 않았을 경우 발생

기본 대기 시간: 1500 ms

```json
{
  "type": "error",
  "request_id": "100",
  "code": 103,
  "message": "Timeout"
}
```

---