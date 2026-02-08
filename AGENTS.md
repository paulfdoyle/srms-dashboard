# Agent instructions

This repo follows the srvmgr deployment pattern.

## Service contract
- Listen on 0.0.0.0:${PORT}
- Provide GET /health
- Log to stdout or stderr
- Configuration via environment variables only
- Support path-based routing (service may be mounted at /<service>)
- Tolerate X-Forwarded-Prefix or a configurable BASE_PATH

## Build and push
- Use deploy/build_push.sh
- Images must target Linux
- Tags are git SHA

## Files
- service.yaml describes name, port, health path, and required env vars
- service.env.example documents required env vars
- deploy/build_push.sh builds and pushes the image

## Deployment
- Image tags are pinned in the central infra repo.
- Deploys run from the infra repo on the VM.
- Subdomains are not available. Traefik routes by URL path.
- The Docker registry cannot be mounted under a custom path; it must be at the host root /v2/ or use a port.
