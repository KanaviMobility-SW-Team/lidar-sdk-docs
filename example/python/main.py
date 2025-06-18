import ctypes
import threading
import os
import time
import sys
import platform
import asyncio
import websockets
import json

# Global WebSocket connection
websocket_connection = None

# SDK Load Status
sdk_load_status = False

# LiDAR UDP Port
lidar_udp_port = 5000


def run_lidar_sdk():
    """
    Initialize and run the LiDAR SDK library.
    Detects system architecture and loads appropriate library file.
    """
    global sdk_load_status
    
    # Check if system is 64-bit using sys.maxsize
    is_64bits = sys.maxsize > 2**32
    is_windows = platform.system() == "Windows"

    # Distinguish between PyInstaller execution and normal execution
    if getattr(sys, 'frozen', False):
        # When running from PyInstaller built exe
        current_dir = sys._MEIPASS
    else:
        # When running as normal Python script
        current_dir = os.path.dirname(os.path.abspath(__file__))
    
    if is_windows:
        if is_64bits:
            dll_path = os.path.join(current_dir, "libs/libkanavi_lidar_sdk-vc143-x64-md-0.1.0.dll")
        else:
            dll_path = os.path.join(current_dir, "libs/libkanavi_lidar_sdk-vc143-x86-md-0.1.0.dll")
    else:  # Ubuntu
        if is_64bits:
            dll_path = os.path.join(current_dir, "libs/libkanavi_lidar_sdk-gcc-x64-0.1.0.so")
        else:
            dll_path = os.path.join(current_dir, "libs/libkanavi_lidar_sdk-gcc-x86-0.1.0.so")

    try:
        dll_path = os.path.abspath(dll_path)
        
        # Modify log path for PyInstaller environment as well
        if getattr(sys, 'frozen', False):
            log_path = os.path.join(os.path.dirname(sys.executable), "logs")
        else:
            log_path = os.path.join(current_dir, "logs")
        
        # Create log directory if it doesn't exist
        os.makedirs(log_path, exist_ok=True)

        lib = ctypes.CDLL(dll_path)
        sdk_load_status = True

        lib.ListenAndServe(str(log_path).encode('utf-8'), False)
            
    except Exception as e:
        sdk_load_status = False
        print(f"Error loading SDK library: {e}")

async def connect_websocket(uri):
    """
    Connect to WebSocket server and return connection.
    """
    try:
        print(f"Connecting to {uri}...")
        websocket = await asyncio.wait_for(
            websockets.connect(uri), 
            timeout=5.0
        )
        print("Connected successfully!")
        return websocket
    except Exception as e:
        print(f"Connection failed: {e}")
        return None

async def send_message(websocket, message):
    """
    Send message through existing WebSocket connection.
    """
    try:
        await websocket.send(json.dumps(message))
        print(f"Sent: {json.dumps(message, indent=2)}")
        
        response = await asyncio.wait_for(
            websocket.recv(), 
            timeout=5.0
        )
        print(f"Received: {response}")
        
    except Exception as e:
        print(f"Message error: {e}")
        
async def recv_message(websocket):
    """
    Receive message through existing WebSocket connection.
    """
    try:
        response = await asyncio.wait_for(
            websocket.recv(), 
            timeout=5.0
        )
        print(f"Received: {response}")
        
    except Exception as e:
        print(f"Message error: {e}")

def get_device_list_message():
    """
    Create a get_device_list request message.
    """
    return {
        "type": "request",
        "request_id": "1",
        "device_id": None,
        "data": {
            "action": "get_device_list",
            "params": {
                "port": lidar_udp_port
            }
        }
    }
    
def subscribe_lidar_message(ip, port, model, id):
    """
    Create a subscribe scan data request message.
    """
    return {
        "type": "request",
        "request_id": "1",
        "device_id": None,
        "data": {
            "action": "subscribe_devices",
            "params": [
                {
                    "ip": int(ip),
                    "port": int(port),
                    "model": int(model),
                    "id": int(id)
                }
            ]
        }
    }
    
def unsubscribe_lidar_message():
    """
    Create a unsubscribe scan data request message.
    """
    return {
        "type": "request",
        "request_id": "1",
        "device_id": None,
        "data": {
            "action": "subscribe_devices",
            "params": []
        }
    }
    
def reset_config_lidar_message(ip, port, model, id):
    """
    Create a reset_config request message.
    """
    return {
        "type": "request",
        "request_id": "1",
        "device_id": {
            "ip": int(ip),
            "port": int(port),
            "model": int(model),
            "id": int(id)
        },
        "data": {
            "action": "reset_config"
        }
    }

async def find_available_port(base_uri, start_port, end_port):
    """
    Try to connect to ports from start_port to end_port and return the first successful connection.
    """
    for port in range(start_port, end_port + 1):
        uri = f"{base_uri}:{port}"
        try:
            print(f"Trying port {port}...")
            websocket = await asyncio.wait_for(
                websockets.connect(uri), 
                timeout=2.0
            )
            print(f"✓ Connected successfully to {uri}")
            return websocket, uri
        except Exception:
            continue
    
    print(f"✗ No available WebSocket server found in port range {start_port}-{end_port}")
    return None, None

async def interactive_mode():
    """
    Run interactive mode with persistent WebSocket connection.
    """
    base_uri = "ws://127.0.0.1"
    
    # Try connecting to ports 5555 - 5655
    print("Scanning for WebSocket server...")
    websocket, connected_uri = await find_available_port(base_uri, 5555, 5655)
    
    if not websocket:
        print("Failed to establish WebSocket connection")
        return
    
    print(f"Using connection: {connected_uri}")
    print("Interactive WebSocket Client")
    print("Commands:")
    print("  1 - Send get_device_list request")
    print("  2 - Subscribe LiDAR Scan Data")
    print("  3 - Display LiDAR Scan Data")
    print("  4 - Stop Subscribe LiDAR Scan Data")
    print("  5 - Send reset_config request")
    print("  q - Quit")
    print("-" * 40)
    
    try:
        while True:
            user_input = await asyncio.get_event_loop().run_in_executor(
                None, input, "Enter command: "
            )
            user_input = user_input.strip()
            
            if user_input == "q":
                print("Exiting...")
                os._exit(1)
            elif user_input == "1":
                message = get_device_list_message()
                await send_message(websocket, message)
            elif user_input == "2":
                lidar_device_ip = await asyncio.get_event_loop().run_in_executor(
                    None, input, "Enter LiDAR Device ip: "
                )
                lidar_device_port = await asyncio.get_event_loop().run_in_executor(
                    None, input, "Enter LiDAR Device port: "
                )
                lidar_device_model = await asyncio.get_event_loop().run_in_executor(
                    None, input, "Enter LiDAR Device model: "
                )
                lidar_device_id = await asyncio.get_event_loop().run_in_executor(
                    None, input, "Enter LiDAR Device id: "
                )
                message = subscribe_lidar_message(lidar_device_ip, lidar_device_port, lidar_device_model, lidar_device_id)
                await send_message(websocket, message)
            elif user_input == "3":
                await recv_message(websocket)
            elif user_input == "4":
                message = unsubscribe_lidar_message()
                await send_message(websocket, message)
            elif user_input == "5":
                lidar_device_ip = await asyncio.get_event_loop().run_in_executor(
                    None, input, "Enter LiDAR Device ip: "
                )
                lidar_device_port = await asyncio.get_event_loop().run_in_executor(
                    None, input, "Enter LiDAR Device port: "
                )
                lidar_device_model = await asyncio.get_event_loop().run_in_executor(
                    None, input, "Enter LiDAR Device model: "
                )
                lidar_device_id = await asyncio.get_event_loop().run_in_executor(
                    None, input, "Enter LiDAR Device id: "
                )
                message = reset_config_lidar_message(lidar_device_ip, lidar_device_port, lidar_device_model, lidar_device_id)
                await send_message(websocket, message)
            else:
                print("Invalid command. Use '1' to send message or 'q' to quit.")
                
    except KeyboardInterrupt:
        print("\nExiting...")
    finally:
        if websocket:
            await websocket.close()
            print("WebSocket connection closed")

def main():
    """
    Main function to start SDK and run interactive mode.
    """
    global lidar_udp_port

    print("Starting LiDAR SDK...")

    # Input LiDAR UDP Port
    lidar_udp_port = int(input("Enter LiDAR UDP Port: "))
    
    # Start SDK in a separate thread
    sdk_thread = threading.Thread(target=run_lidar_sdk, daemon=True)
    sdk_thread.start()
    
    # Wait a moment for SDK to initialize
    time.sleep(2)

    if not sdk_load_status:
        print("SDK initialization failed")
        return
    
    # Start interactive mode with persistent connection
    asyncio.run(interactive_mode())

if __name__ == "__main__":
    main()