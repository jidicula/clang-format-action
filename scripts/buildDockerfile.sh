#!/usr/bin/env bash

set -e
set -x

docker build . $ADDITIONAL_DOCKER_BUILD_ARGS --file Dockerfile --tag local/clang-format-action:latest
