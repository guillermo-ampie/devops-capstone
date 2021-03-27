#!/usr/bin/env bash

# This tags and uploads an image to Docker Hub

# Set vars
DOCKER_HUB_ID="registry.hub.docker.com/gampie"
DOCKER_REPOSITORY="hello-app"
DEPLOYMENT_NAME=${DOCKER_REPOSITORY}
CONTAINER_PORT=80
VERSION=1.000
REPLICAS=4

dockerpath=${DOCKER_HUB_ID}/${DOCKER_REPOSITORY}:${VERSION}

# Run the Docker Hub container with kubernetes
kubectl create deployment ${DEPLOYMENT_NAME} --image=${dockerpath} --replicas=${REPLICAS} &&
    kubectl expose deployment/${DEPLOYMENT_NAME} --type="LoadBalancer" --port ${CONTAINER_PORT}

# List kubernetes resources
echo
echo "Listing deployments"
kubectl get deployments -o wide
echo
echo "Listing services"
kubectl get services -o wide
echo
echo "Listing pods"
kubectl get pods -o wide

# Forward the container port to a host port
#kubectl port-forward service/${DEPLOYMENT_NAME} ${HOST_PORT}:${CONTAINER_PORT}
