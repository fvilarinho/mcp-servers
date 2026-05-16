# 📷 Cameras Automation MCP Server

A lightweight **MCP (Model Context Protocol) server** for managing cameras via HTTP APIs. It uses a configuration-driven approach and exposes a secure API through `mcpo`.

## 🚀 Features

| Tool                    | Description                   |
| ----------------------- |-------------------------------|
| `available_cameras()`   | List available cameras        |
| `describe_camera(name)` | Show camera details and stats |
| `turn_on_camera(name)`  | Turn on the camera            |
| `turn_off_camera(name)` | Turn off the camerq           |

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
├── .env
├── Dockerfile
├── build.sh
├── publish.sh
├── start.sh
├── stop.sh
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

## 📦 Installation & Dependencies

Python libraries dependencies:

```
- requests
- mcp
m- cpo
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
mcpo --host 0.0.0.0 --port <PORT> --api-key <TOKEN> -- python server.py
```

# 🐳 Docker

The process to build, publish, start and stop the docker container is defined as followed using the `.env` file

| Key          | Description                                |
|--------------|--------------------------------------------|
| REPOSITORY_URL | The URL of the Docker Registry             |
| REPOSITORY_ID | The Docker Registry Repository ID          |
| REPOSITORY_PASSWORD | The Docker Registry Repository Password    |
| BUILD_VERSION | The version number of the Docker Container |

## Build

```bash
./build.sh
```
This will run `docker build -t <REPOSITORY_URL>/<REPOSITORY_ID>/mcp-servers/cameras-automation:<BUILD_VERSION> .`

## Publish

```bash
./publish.sh
```
This will run `docker push <REPOSITORY_URL>/<REPOSITORY_ID>/mcp-servers/cameras-automation:<BUILD_VERSION>`

## Run

```bash
./start.sh
```
This will run `docker run -d -p "<PORT>:<PORT>" --name cameras-automation <REPOSITORY_URL>/<REPOSITORY_ID>/mcp-servers/cameras-automation:<BUILD_VERSION>`

## Stop

```bash
./stop.sh
```
This will run `docker stop cameras-automation`

## Override Config

```bash
docker run -d \
  -p <PORT>:<PORT> \
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