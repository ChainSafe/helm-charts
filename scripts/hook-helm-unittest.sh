#!/usr/bin/env sh
set -eu
# Prefer the local plugin (helm unittest); fall back to the Docker image in CI.
if helm plugin list 2>/dev/null | grep -q unittest; then
  helm unittest charts/*
else
  docker run --rm -v "$(pwd)":/apps helmunittest/helm-unittest charts/*
fi
