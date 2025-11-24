ARG UBUNTU_VERSION
FROM ubuntu:${UBUNTU_VERSION}

ARG CLANG_FORMAT_VERSION

RUN pip install "clang-format~=$CLANG_FORMAT_VERSION" \
	&& mv -f "$(which clang-format)" /usr/bin/clang-format

WORKDIR /

COPY check.sh .

ENTRYPOINT ["/usr/bin/clang-format"]
