#!/bin/bash
# install-clang-format.sh
set -euo pipefail

VERSION="${1:-}"
UBUNTU_REPO_MAX_VERSION=19

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" >&2
}

extract_major_version() {
    echo "$1" | grep -o '^[0-9]\+' || echo ""
}

install_from_ubuntu_repo() {
    local version="$1"
    log "Installing clang-format-$version from Ubuntu repository"

    apt-get update
    apt-get install --no-install-recommends -y "clang-format-$version"
    cleanup_apt
    mv "/usr/bin/clang-format-$version" /usr/bin/clang-format
}

install_from_llvm_repo() {
    local version="$1"
    log "Installing clang-format-$version from LLVM repository"

    apt-get update
    apt-get install --no-install-recommends -y ca-certificates lsb-release software-properties-common gnupg wget

    wget -O llvm.sh https://apt.llvm.org/llvm.sh
    chmod +x llvm.sh
    ./llvm.sh "$version"
    rm llvm.sh

    apt-get install --no-install-recommends -y "clang-format-$version"
    cleanup_apt
    mv "/usr/bin/clang-format-$version" /usr/bin/clang-format
}

cleanup_apt() {
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false
    apt-get clean -y
    rm -rf /var/lib/apt/lists/*
}

main() {
    if [ -z "$VERSION" ]; then
        log "ERROR: No version specified"
        log "Usage: $0 <clang-format-version>"
        exit 1
    fi

    log "Processing clang-format version: $VERSION"

    MAJOR_VERSION=$(extract_major_version "$VERSION")

    if [ -n "$MAJOR_VERSION" ] && [ "$MAJOR_VERSION" -le $UBUNTU_REPO_MAX_VERSION ]; then
        install_from_ubuntu_repo "$VERSION"
    else
        install_from_llvm_repo "$VERSION"
    fi

    log "Successfully installed clang-format version $VERSION"
}

main "$@"
