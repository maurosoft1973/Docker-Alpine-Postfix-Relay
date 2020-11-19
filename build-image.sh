#!/bin/bash
# Description: Build image and push to repository
# Maintainer: Mauro Cardillo
# DOCKER_HUB_USER and DOCKER_HUB_PASSWORD is user environment variable

IMAGE=maurosoft1973/alpine-postfix-relay
BUILD_DATE=$(date +"%Y-%m-%d")

echo "Remove image ${IMAGE}:test"
docker rmi -f ${IMAGE}:test > /dev/null 2>&1

echo "Build Image: ${IMAGE}:test"
docker build --build-arg BUILD_DATE=$BUILD_DATE -t ${IMAGE}:test .

echo "Login Docker HUB"
echo "$DOCKER_HUB_PASSWORD" | docker login -u "$DOCKER_HUB_USER" --password-stdin

echo "Push Image"
docker push ${IMAGE}:test

echo "Pull Image"
docker pull ${IMAGE}:test
