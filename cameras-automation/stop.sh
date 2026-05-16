#!/usr/bin/env bash

# Prepares the environment to execute this script.
function prepareToStop() {
    DOCKER_CMD=$(which docker)

    source .env
}

# Stops the container.
function stop() {
    prepareToStop

    $DOCKER_CMD stop "cameras-automation" > /dev/null 2>&1
    $DOCKER_CMD rm -f "cameras-automation" > /dev/null 2>&1
}

stop