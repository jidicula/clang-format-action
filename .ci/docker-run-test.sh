#!/usr/bin/env bash

# build the docker container
docker build . --file Dockerfile --tag clang-format-action-test --no-cache

# should succeed
docker run -e CLANG_FORMAT_VERSION=11 -e CHECK_PATH=known_pass -e EXCLUDE_REGEX=capi -e GITHUB_WORKSPACE=/test -it -v $(pwd)/test:/test --privileged clang-format-action-test
if [ "$?" != "0" ]; then
    echo "files that should succeed have failed!"
    exit 1
fi

# should fail
docker run -e CLANG_FORMAT_VERSION=11 -e CHECK_PATH=known_fail -e EXCLUDE_REGEX=capi -e GITHUB_WORKSPACE=/test -it -v $(pwd)/test:/test --privileged clang-format-action-test
if [ "$?" == "0" ]; then
    echo "files that should fail have succeeded!"
    exit 2
fi