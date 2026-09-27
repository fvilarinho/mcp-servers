# MCP Servers

A collection of [Model Context Protocol (MCP)](https://modelcontextprotocol.io/) servers that expose home-automation capabilities as tools that AI assistants can call.

Each subdirectory is a self-contained MCP server packaged as a Docker container and exposed over HTTP via [`mcpo`](https://github.com/open-webui/mcpo).

## Servers

### `cameras`

An MCP server that controls network cameras through their HTTP APIs. Cameras are defined in a configuration file, and each tool call resolves the target camera's URL, bearer token, and timeout from that configuration.

**Exposed tools:**

| Tool | Description |
|------|-------------|
| `available_cameras()` | Lists all cameras defined in the configuration (excludes the `server` section). |
| `describe_camera(name)` | Returns stats/details for a camera by name (calls `<url>/stats`). |
| `turn_on_camera(name)` | Turns a camera on (calls `<url>/on`). |
| `turn_off_camera(name)` | Turns a camera off (calls `<url>/off`). |

The `name` argument matches a section name in `config.ini`. A trailing `" camera"` in the name is stripped automatically (e.g. `"living room camera"` resolves to the `living room` section).

## Requirements

- [Docker](https://www.docker.com/) with Compose
- For local (non-container) runs: Python 3

## Configuration

Each server reads its settings from `etc/config.ini`. A template is provided at `etc/config.ini.template`:

```ini
[server]
bearer_token = <MCP Server API Key>

[camera]
bearer_token = <Camera API Key>
url          = <Camera API URL>
timeout      = <Timeout>
```

- The `[server]` section holds the API key used to protect the MCP server endpoint.
- Every other section defines a camera. The section name is the camera's `name`, and it must provide `bearer_token`, `url`, and `timeout` (seconds). Add one section per camera.

Copy the template and fill in your values:

```bash
cd cameras
cp etc/config.ini.template etc/config.ini
# edit etc/config.ini
```

### Environment variables

The build and publish scripts read Docker registry settings from a `.env` file. A template is provided at `.env.template`:

```bash
export REPOSITORY_URL=<Docker Registry URL>
export REPOSITORY_ID=<Docker Registry Repository ID>
export REPOSITORY_PASSWORD=<Docker Registry Password>
export BUILD_VERSION=<Build Version>
```

Copy it and fill in your values:

```bash
cd cameras
cp .env.template .env
# edit .env
```

## Usage

All commands are run from within a server directory (e.g. `cameras/`).

### Build

Builds the container image using Docker Compose:

```bash
./build.sh
```

### Start / Stop

`start.sh` stops any running instance and starts a fresh one in the background; `stop.sh` tears it down:

```bash
./start.sh
./stop.sh
```

The server listens on port `8000` (see `docker-compose.yml`). `etc/config.ini` is mounted into the container at runtime, so configuration changes do not require a rebuild.

### Publish

Logs in to the configured Docker registry and pushes the image:

```bash
./publish.sh
```

## How it works

- **`Dockerfile`** builds an Alpine-based image, installs Python and the dependencies from `bin/requirements.txt` (`requests`, `mcp`, `mcpo`), and sets `bin/start.sh` as the entrypoint.
- **`bin/start.sh`** reads the `[server]` bearer token from `config.ini` and launches the MCP server behind `mcpo`, exposing it as an HTTP endpoint on `0.0.0.0:8000` protected by that API key.
- **`bin/server.py`** implements the MCP tools with [FastMCP](https://github.com/jlowin/fastmcp), translating tool calls into authenticated HTTP requests against each camera's API.

## Project layout

```
mcp-servers/
├── LICENSE
└── cameras/
    ├── build.sh              # Build the Docker image
    ├── publish.sh            # Push the image to a registry
    ├── start.sh / stop.sh    # Run / stop the container
    ├── docker-compose.yml    # Service definition (port 8000, config mount)
    ├── Dockerfile            # Alpine + Python image
    ├── .env.template         # Docker registry settings template
    ├── bin/
    │   ├── server.py         # MCP server + tool definitions
    │   ├── start.sh          # Container entrypoint (launches mcpo)
    │   ├── install.sh        # Sets up venv and installs deps
    │   └── requirements.txt  # Python dependencies
    └── etc/
        └── config.ini.template  # Server + camera configuration template
```

## License

See [LICENSE](LICENSE).
