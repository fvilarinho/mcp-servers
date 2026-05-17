#!/usr/bin/env bash

# Prepares the environment to execute this script.
function prepareToStop() {
    DOCKER_CMD=$(which docker)

    source .env
}

# Stops the container.
function stop() {
    prepareToStop

    $DOCKER_CMD compose down
}

stop