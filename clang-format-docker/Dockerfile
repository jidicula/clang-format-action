ARG UBUNTU_VERSION
FROM ubuntu:${UBUNTU_VERSION}

ARG CLANG_FORMAT_VERSION

COPY install-clang-format.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/install-clang-format.sh && \
    bash /usr/local/bin/install-clang-format.sh "${CLANG_FORMAT_VERSION}"

WORKDIR /

COPY check.sh .

ENTRYPOINT ["/usr/bin/clang-format"]
