# 📷 Cameras Automation MCP Server

A lightweight **MCP (Model Context Protocol) server** for managing cameras via HTTP APIs. It uses a configuration-driven approach and exposes a secure API through `mcpo`.

---

## 🚀 Features

| Tool                    | Description                   |
| ----------------------- |-------------------------------|
| `available_cameras()`   | List available cameras        |
| `describe_camera(name)` | Show camera details and stats |
| `turn_on_camera(name)`  | Turn on the camera            |
| `turn_off_camera(name)` | Turn off the camerq           |

---

## 🧱 Project Structure

```
.
├── bin/
│   ├── server.py
│   ├── requirements.txt
│   ├── install.sh
│   └── start.sh
├── etc/
│   └── config.ini
├── Dockerfile
```

---

## ⚙️ Configuration

It is config-based setup (no hardcoding)

Path:

```
etc/config.ini
```

Example:

```ini
[server]
bearer_token = super_secret_token

[camera1]
url = http://<CAMERA_HOST>/api
bearer_token = camera_token
timeout = 5
```

### Fields

| Key          | Description                                                                                  |
| ------------ |----------------------------------------------------------------------------------------------|
| url          | Camera API base URL (Check the project https://git.vila.net.br/fvilarinho/automation/cameras |
| bearer_token | Auth token                                                                                   |
| timeout      | Request timeout (seconds)                                                                    |

---

## 📦 Installation & Dependencies

Dependencies:

```
requests
mcp
mcpo
```

### Local Setup

From the `bin/` directory:

```bash
cd bin
chmod +x install.sh
./install.sh
```

This script:

* Creates the virtual environment (`.venv`)
* Installs all required dependencies

---

## ▶️ Run & How It Works (Local)

Start the server:

```bash
cd bin
./start.sh
```

### What happens:

1. Activates the virtual environment (`.venv`)
2. Reads `server.bearer_token` from `etc/config.ini`
3. Starts the API gateway and MCP server:

```bash
mcpo --host 0.0.0.0 --port 8000 --api-key <TOKEN> -- python server.py
```

# 🐳 Docker

## Build

```bash
docker build -t cameras-automation .
```

## Run

```bash
docker run -d -p 8000:8000 --name cameras-server cameras-automation
```

## Override Config

```bash
docker run -d \
  -p 8000:8000 \
  -v $(pwd)/etc/config.ini:/home/server/etc/config.ini \
  cameras-automation
```

---

## 🔌 Using this MCP Server in OpenWebUI (Ollama)

You can integrate this MCP server as a tool inside OpenWebUI when using Ollama.

### 1. Start the MCP Server

Make sure your server is running and accessible:

```
http://<OPENWEBUI_HOST>:<OPENWEBUI_PORT>
```

> Replace `<OPENWEBUI_HOST>` with your server hostname or IP.
> Replace `<OPENWEBUI_PORT>` with your server port.

---

### 2. Open OpenWebUI Tool Server Settings

Navigate to:

```
Settings → Admin Panel → Integrations → Manage Tool Servers
```

Then click **Add**.

---

### 3. Configure the MCP Server

Fill in:

* **Name:** Cameras Automation
* **URL:** `http://<MCPSERVER_HOST>:<MCPSERVER_PORT>`
* **API Key:** your `server.bearer_token` from `config.ini`

> Replace `<MCPSERVER_HOST>` with your server hostname or IP.
> Replace `<MCPSERVER_PORT>` with your server port.

---

### 4. Enable the Tool

* Assign the tool server to your model (e.g., an Ollama model)
* Ensure tool usage is enabled in your chat session

---

### 5. Example Usage

You can now ask:

* "List available cameras"
* "Turn on camera1"
* "Get stats from camera1"

The model will automatically invoke the MCP tools.

---

## 🔐 Security

* All the APIs are protected via `bearer_token`
* Do not commit any secrets or credentials
* Use volume mounts or secrets in production

---

## 🧠 Architecture

```
Client → OpenWebUI → mcpo → MCP server → Camera APIs
```

---

## 🧩 Future Improvements

* Health checks
* Logging
* Retry logic
* Async support
* Docker healthchecks

---

## 📄 License

This project is licensed under the Apache License 2.0.

See the full license here:
[https://www.apache.org/licenses/LICENSE-2.0](https://www.apache.org/licenses/LICENSE-2.0)