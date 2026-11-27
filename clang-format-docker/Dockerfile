ARG BASE_IMAGE
FROM ${BASE_IMAGE}

ARG CLANG_FORMAT_VERSION
ARG APT_SOURCE
ARG APT_TARGET

RUN if [ -n "${APT_SOURCE}" ]; then \
		printf '%s\n' "${APT_SOURCE}" > /etc/apt/sources.list.d/clang-format.list; \
	fi \
	&& apt-get update \
	&& set -- \
	&& if [ -n "${APT_TARGET}" ]; then set -- -t "${APT_TARGET}"; fi \
	&& apt-get install --no-install-recommends -y "$@" \
	"clang-format-${CLANG_FORMAT_VERSION}" \
	# Clean cache
	&& apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
	&& rm -f /etc/apt/sources.list.d/clang-format.list \
	&& apt-get clean -y && rm -rf /var/lib/apt/lists/* \
	&& mv "/usr/bin/clang-format-${CLANG_FORMAT_VERSION}" /usr/bin/clang-format

WORKDIR /

COPY check.sh .

ENTRYPOINT ["/usr/bin/clang-format"]
