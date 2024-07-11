ARG UBUNTU_VERSION
FROM ubuntu:${UBUNTU_VERSION}

ARG CLANG_FORMAT_VERSION

RUN wget https://apt.llvm.org/llvm.sh \
	&& chmod u+x llvm.sh \
	&& sudo ./llvm.sh ${CLANG_FORMAT_VERSION} \

WORKDIR /

COPY check.sh .

ENTRYPOINT ["/usr/bin/clang-format"]
