#!/usr/bin/env bash

# Prepares the environment to execute this script.
function prepareToStart() {
    DOCKER_CMD=$(which docker)

    source .env
}

# Starts the container.
function start() {
    prepareToStart

    $DOCKER_CMD compose up -d
}

./stop.sh

start