#!/usr/bin/env bash

FALLBACK_STYLE="llvm"
EXCLUDE_REGEX="capital"
CLANG_FORMAT_VERSION="10"
WORKSPACE="/test"

root_dir="$(dirname "$(readlink -f "$0")")/.."

# build the docker container
"$root_dir/scripts/generateDockerfile.sh" "$CLANG_FORMAT_VERSION"
"$root_dir/scripts/buildDockerfile.sh"

ADDITIONAL_DOCKER_RUN_ARGS="-v $(pwd)/test:/test"
export ADDITIONAL_DOCKER_RUN_ARGS

# should succeed
"$root_dir/scripts/runDockerfile.sh" "$WORKSPACE" known_pass "$FALLBACK_STYLE" "$EXCLUDE_REGEX"
docker_status="$?"
if [[ "$docker_status" != "0" ]]; then
	echo "files that should succeed have failed!"
	exit 1
fi

# should fail
"$root_dir/scripts/runDockerfile.sh" "$WORKSPACE" known_fail "$FALLBACK_STYLE" "$EXCLUDE_REGEX"
docker_status="$?"
if [[ "$docker_status" == "0" ]]; then
	echo "files that should fail have succeeded!"
	exit 2
fi
