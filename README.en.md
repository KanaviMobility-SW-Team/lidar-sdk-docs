# LiDAR SDK Documentation

This repository contains documentation related to the LiDAR SDK.

## SDK Usage

This SDK is developed in Rust and can be loaded and used on Windows, Linux, and Android platforms.

### Entry Function

- **Function Name**: `ListenAndServe`
- **Parameters**: 
  - `log_path` (string): Directory path for log file storage
  - `display_terminal_log` (boolean): Console log output setting

### Operation Mode

- The function **runs continuously without termination** when called
- Internally operates a WebSocket server (automatically scans ports 5555-5655)
- **Execution in a separate thread is recommended**

### Usage Examples

For detailed implementation examples, refer to the [`example`](example/) folder.

---

## Supported Models

|Model|Supported F/W Version|Max Range[m]|Field of View|Channels|
|-|-|-|-|-|
|`R2`|`5.1.2+`|`70`|`120`|`2`|
|`R4`|`3.2.4+`|`50`|`100`|`4`|
|`R270`|`1.2.1+`|`30`|`270`|`1`|


## WebSocket API ([`🔗`](api/websocket_api.md))

Description of message formats used in the SDK.

- **[WebSocket API](api/websocket_api.md)** - API overview and message flow
- **[Request](api/request.md)** - Detailed request message specification
- **[Response](api/response.md)** - Detailed response message specification  
- **[Notify](api/notify.md)** - Real-time notification messages
- **[Error](api/error.md)** - Error codes

## Releases
Documentation files and release packages are available in the Releases tab.

## License
Published under the CC BY 4.0 License.

> Korean version: [README.md](README.md)