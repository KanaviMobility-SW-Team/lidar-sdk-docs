# LiDAR SDK 문서

이 저장소는 LiDAR SDK 문서와 관련된 내용을 담고 있습니다.

## 지원 모델

|모델|지원 F/W 버전|최대 거리[m]|시야각|채널 수|
|-|-|-|-|-|
|`R2`|`5.1.2+`|`70`|`120`|`2`|
|`R4`|`3.2.4+`|`50`|`100`|`4`|
|`R270`|`1.2.1+`|`30`|`270`|`1`|

---

## SDK 사용법

해당 SDK는 Rust로 제작되었으며, Windows, Linux, Android에서 로드하여 사용 가능합니다.

### 진입 함수

- **함수명**: `ListenAndServe`
- **매개변수**: 
  - `log_path` (string): 로그 파일 저장 디렉토리 경로
  - `display_terminal_log` (boolean): 콘솔에 로그 출력 여부 설정

### 동작 방식

- 함수 호출 시 **종료되지 않고 계속 실행**됩니다
- 내부적으로 WebSocket 서버를 구동합니다 (포트 5555-5655 자동 스캔)
- **별도 스레드에서 실행**하는 것을 권장합니다

### 사용 예제

자세한 구현 예제는 [`example`](example/) 폴더를 참조하세요.

---

## WebSocket API ([`🔗`](api/websocket_api.md))

SDK에서 사용하는 메시지 형식 설명입니다.

- **[WebSocket API](api/websocket_api.md)** - API 개요 및 메시지 흐름
- **[Request](api/request.md)** - 요청 메시지 상세 명세
- **[Response](api/response.md)** - 응답 메시지 상세 명세  
- **[Notify](api/notify.md)** - 실시간 알림 메시지
- **[Error](api/error.md)** - 에러 코드

## 릴리즈
문서 파일과 배포 파일은 Releases 탭에서 확인하세요.

## 라이선스 (License)
CC BY 4.0 라이선스 하에 공개됩니다.

> English version: [README.md](README.en.md)