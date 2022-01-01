#!/usr/bin/env bash

set -e
set -x

docker run $ADDITIONAL_DOCKER_RUN_ARGS local/clang-format-action:latest "$@"
