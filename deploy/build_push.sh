#!/usr/bin/env bash
set -euo pipefail

IMAGE="${IMAGE:-registry.local:5000/example-service}"
PLATFORM="${PLATFORM:-linux/amd64}"
TAG="${TAG:-$(git rev-parse --short HEAD)}"

if ! command -v docker >/dev/null 2>&1; then
  echo "docker is required" >&2
  exit 1
fi

if ! docker buildx version >/dev/null 2>&1; then
  echo "docker buildx is required" >&2
  exit 1
fi

echo "Building and pushing: ${IMAGE}:${TAG}"
echo "Platform: ${PLATFORM}"

docker buildx build \
  --platform "${PLATFORM}" \
  -t "${IMAGE}:${TAG}" \
  --push \
  .

echo "Done"
echo "Next: update the image tag in the infra repo env file"
