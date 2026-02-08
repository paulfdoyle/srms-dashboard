#!/usr/bin/env bash
set -euo pipefail

REGISTRY_HOST="az-srmsrpt-01.campus.tudublin.ie"
IMAGE="${REGISTRY_HOST}/srms-dashboard"

cd "$(dirname "$0")"

if ! command -v docker >/dev/null 2>&1; then
  echo "docker is required" >&2
  exit 1
fi

if ! docker buildx version >/dev/null 2>&1; then
  echo "docker buildx is required" >&2
  exit 1
fi

if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  GIT_SHA="$(git rev-parse --short HEAD)"
else
  GIT_SHA="nogit"
fi

TAG="${GIT_SHA}-$(date +%Y%m%d%H%M%S)"

IMAGE="$IMAGE" PLATFORM=linux/amd64 TAG="$TAG" ./deploy/build_push.sh

echo
echo "Pushed: ${IMAGE}:${TAG}"
echo "Next on VM:"
echo "cd /opt/srms-dashboard"
echo "sed -i \"s|image: .*|image: ${IMAGE}:${TAG}|\" compose.srms-dashboard.yml"
echo "docker compose -p srms-dashboard -f compose.srms-dashboard.yml pull"
echo "docker compose -p srms-dashboard -f compose.srms-dashboard.yml up -d"
