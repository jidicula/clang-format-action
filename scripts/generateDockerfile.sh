#!/usr/bin/env bash

set -e

echo "Generating Dockerfile in $(pwd)"

llvm_version="$1"

if [ -z "$llvm_version" ]; then
	echo "No LLVM version given!"
	exit 1
fi

root_dir="$(dirname "$(readlink -f "$0")")/.."

if ! [ "$root_dir" -ef "$(pwd)" ]; then
	# This script is not executed from within our root dir -> we have to explicitly copy the entrypoint.sh script here
	cp "$root_dir/entrypoint.sh" .
fi

content=$(
	cat <<EOF
FROM silkeh/clang:$llvm_version

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

EOF
)

echo "$content" >Dockerfile
