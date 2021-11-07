#!/usr/bin/env bash

FALLBACK_STYLE="llvm"
EXCLUDE_REGEX="capital"

# build the docker container
docker build . --file Dockerfile --tag clang-format-action-test --no-cache
docker_status="$?"
if [[ "$docker_status" != "0" ]]; then
	echo "failed to build the dockerfile"
	exit 1
fi

# should succeed
docker run -e CLANG_FORMAT_VERSION=13 -e GITHUB_WORKSPACE=/test -v "$(pwd)"/test:/test --privileged clang-format-action-test known_pass $FALLBACK_STYLE $EXCLUDE_REGEX
docker_status="$?"
if [[ "$docker_status" != "0" ]]; then
	echo "files that should succeed have failed!"
	exit 1
fi

# should fail
docker run -e CLANG_FORMAT_VERSION=13 -e GITHUB_WORKSPACE=/test -v "$(pwd)"/test:/test --privileged clang-format-action-test known_fail $FALLBACK_STYLE $EXCLUDE_REGEX
docker_status="$?"
if [[ "$docker_status" == "0" ]]; then
	echo "files that should fail have succeeded!"
	exit 2
fi
