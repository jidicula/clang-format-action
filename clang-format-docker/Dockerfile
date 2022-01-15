ARG UBUNTU_VERSION
FROM ubuntu:${UBUNTU_VERSION}

ARG CLANG_FORMAT_VERSION

RUN apt-get update \
    && apt-get install --no-install-recommends -y \
    clang-format-${CLANG_FORMAT_VERSION} \
    # Clean cache
    && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
    && apt-get clean -y && rm -rf /var/lib/apt/lists/* \
    && mv /usr/bin/clang-format-${CLANG_FORMAT_VERSION} /usr/bin/clang-format


ENTRYPOINT ["/usr/bin/clang-format"]
