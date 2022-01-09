FROM debian:bullseye-slim
COPY bin/clang-format /clang-format

ENTRYPOINT ["/clang-format", "-n", "--Werror", "--style=file"]
