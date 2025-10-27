ARG UBUNTU_VERSION
FROM ubuntu:${UBUNTU_VERSION}

ARG CLANG_FORMAT_VERSION


RUN if [ "${CLANG_FORMAT_VERSION}" <= "19"]; then \
        apt-get update \
    	&& apt-get install --no-install-recommends -y \
    	clang-format-${CLANG_FORMAT_VERSION} \
    	# Clean cache
    	&& apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
    	&& apt-get clean -y && rm -rf /var/lib/apt/lists/* \
    	&& mv /usr/bin/clang-format-${CLANG_FORMAT_VERSION} /usr/bin/clang-format; \
    else \
        apt-get update \
        && wget https://apt.llvm.org/llvm.sh \
        && chmod +x llvm.sh \
        && ./llvm.sh ${CLANG_FORMAT_VERSION} all \
        && rm llvm.sh \
        # Clean cache
        && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
        && apt-get clean -y && rm -rf /var/lib/apt/lists/* \
        && mv /usr/bin/clang-format-${CLANG_FORMAT_VERSION} /usr/bin/clang-format; \
    fi

WORKDIR /

COPY check.sh .

ENTRYPOINT ["/usr/bin/clang-format"]
