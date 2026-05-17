#!/usr/bin/env bash

# Prepares the environment to execute this script.
function prepareToBuild() {
    DOCKER_CMD=$(which docker)

    source .env
}

# Builds the container.
function build() {
    prepareToBuild

    $DOCKER_CMD compose build
}

build