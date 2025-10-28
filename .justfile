default:
    @just --list

[doc("Run bats tests")]
test:
    bats test/test-install-clang-format.bats
