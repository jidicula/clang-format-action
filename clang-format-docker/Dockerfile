ARG UBUNTU_VERSION
FROM ubuntu:${UBUNTU_VERSION}

ARG CLANG_FORMAT_VERSION
ENV CLANG_FORMAT_MAJOR_VERSION=${CLANG_FORMAT_VERSION%%.*}

RUN apt-get update \
	&& apt-get install --no-install-recommends -y \
	clang-format-${CLANG_FORMAT_MAJOR_VERSION} \
	&& mv /usr/bin/clang-format-${CLANG_FORMAT_MAJOR_VERSION} /usr/bin/clang-format

RUN [ $CLANG_FORMAT_VERSION != $CLANG_FORMAT_MAJOR_VERSION ] \
	&& apt-get install --no-install-recommends -y python-pip \
	&& pip install "clang-format~=$CLANG_FORMAT_VERSION" \
	&& mv -f "$(which clang-format)" /usr/bin/clang-format

# Clean cache
RUN apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
	&& apt-get clean -y && rm -rf /var/lib/apt/lists/*

WORKDIR /

COPY check.sh .

ENTRYPOINT ["/usr/bin/clang-format"]
