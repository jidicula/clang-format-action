FROM scratch
COPY bin/clang-format .

ENTRYPOINT ["clang-format", "-n", "--Werror", "--style=file"]
