ARG UBUNTU_VERSION
FROM ubuntu:${UBUNTU_VERSION}

ARG CLANG_FORMAT_VERSION
ENV PIP_ROOT_USER_ACTION=ignore
ENV PIP_BREAK_SYSTEM_PACKAGES=1

RUN apt-get update \
	&& apt-get install --no-install-recommends -y python3-pip \
	&& pip install -v "$( \
		echo "$CLANG_FORMAT_VERSION" | grep -qF '.' \
		&& echo "clang-format==${CLANG_FORMAT_VERSION}" \
		|| echo "clang-format==${CLANG_FORMAT_VERSION}.*" \
	)" \
	# Clean cache
	&& apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
	&& apt-get clean -y && rm -rf /var/lib/apt/lists/* \
	&& mv /usr/local/bin/clang-format /usr/bin/clang-format

WORKDIR /

COPY check.sh .

ENTRYPOINT ["/usr/bin/clang-format"]
