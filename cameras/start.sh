#!/usr/bin/env bash

# Prepares the environment to execute this script.
function prepareToStart() {
    DOCKER_CMD=$(which docker)

    source .env
}

# Starts the container.
function start() {
    prepareToStart

    $DOCKER_CMD run -d -p "8000:8000" --name "cameras-mcpserver" "$REPOSITORY_URL/$REPOSITORY_ID/mcp-servers/cameras:$BUILD_VERSION"
}

./stop.sh

start