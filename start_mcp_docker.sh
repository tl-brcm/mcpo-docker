#!/bin/bash

docker run \
  -p 8000:8000 \
  -v "$(pwd)/config.json:/app/config.json" \
  ghcr.io/open-webui/mcpo:main \
  --api-key "top-secret" \
  --config /app/config.json
