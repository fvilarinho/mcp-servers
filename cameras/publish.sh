#!/usr/bin/env bash

# Prepares the environment to execute this script.
function prepareToPublish() {
    DOCKER_CMD=$(which docker)

    source .env
}

# Publishes the container.
function publish() {
    prepareToPublish

    echo $REPOSITORY_PASSWORD | $DOCKER_CMD login -u $REPOSITORY_ID $REPOSITORY_URL --password-stdin

    $DOCKER_CMD push "$REPOSITORY_URL/$REPOSITORY_ID/mcp-servers/cameras:$BUILD_VERSION"
}

publish