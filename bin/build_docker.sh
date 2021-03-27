#!/usr/bin/env bash

CONTAINER_NAME="hello-app"
VERSION=1.000

# Step 1:
# Build image and add a descriptive tag
docker build --tag ${CONTAINER_NAME}:${VERSION} hello_app
