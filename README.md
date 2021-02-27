| Branch | Docker Image CI | shell-lint |
|--------|-----------------|------------|
| `main`   | [![Docker Image CI](https://github.com/jidicula/clang-format-action/workflows/Docker%20Image%20CI/badge.svg?branch=main)](https://github.com/jidicula/clang-format-action/actions?query=workflow%3A%22Docker+Image+CI%22+branch%3Amain) | [![shell-lint](https://github.com/jidicula/clang-format-action/workflows/shell-lint/badge.svg?branch=main)](https://github.com/jidicula/clang-format-action/actions?query=workflow%3Ashell-lint+branch%3Amain) |
| `dev`    | [![Docker Image CI](https://github.com/jidicula/clang-format-action/workflows/Docker%20Image%20CI/badge.svg?branch=dev)](https://github.com/jidicula/clang-format-action/actions?query=workflow%3A%22Docker+Image+CI%22+branch%3Adev) | [![shell-lint](https://github.com/jidicula/clang-format-action/workflows/shell-lint/badge.svg?branch=dev)](https://github.com/jidicula/clang-format-action/actions?query=workflow%3Ashell-lint+branch%3Adev) |

# clang-format-action
GitHub Action for clang-format

## Inputs
* `clang-format-version` [optional]: The version of `clang-format` that you want to run on your codebase.
  * Default: `10`
  * Available versions: every version of `clang-format` available on [Ubuntu Groovy](https://packages.ubuntu.com/search?suite=groovy&searchon=names&keywords=clang-format).
* `check-path` [optional]: The path to the directory in the repo that should be checked for C/C++ formatting.
  * Default: `.`
  * For cleaner output (i.e. with no double-slashed paths), the final directory in this path should have no trailing slash, e.g. `src` and not `src/`.
* `fallback-style` [optional]: The fallback style for `clang-format` if no `.clang-format` file exists in your repository.
  * Default: `llvm`
  * Available values: `LLVM`, `Google`, `Chromium`, `Mozilla`, `WebKit` and others listed in the `clang-format` [docs for BasedOnStyle](https://clang.llvm.org/docs/ClangFormatStyleOptions.html#configurable-format-style-options).

This action checks all C/C++ files in the provided directory in the GitHub workspace are formatted correctly using `clang-format`. If no directory is provided or the provided path is not a directory in the GitHub workspace, all C/C++ files are checked.

The following file extensions are checked:
* Header files:
  * `.h`
  * `.H`
  * `.hpp`
  * `.hh`
  * `.h++`
  * `.hxx `
* Source files:
  * `.c`
  * `.C`
  * `.cpp`
  * `.cc`
  * `.c++`
  * `.cxx`

## Returns:

* SUCCESS: zero exit-code if C/C++ files in `check-path` are formatted correctly
* FAILURE: nonzero exit-code if C/C++ files in `check-path` are not formatted correctly

Define your own formatting rules in a `.clang-format` file at your repository root. Otherwise, the LLVM style guide is used as a default fallback. My preference is the [Linux Project format](https://github.com/torvalds/linux/blob/master/.clang-format).

# Usage

To use this action, create a `.github/workflows/clang-format-check.yml` in your repository containing:

```
name: clang-format Check
on: [push, PR]
jobs:
  formatting-check:
    name: Formatting Check
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
    - name: Run clang-format style check for C/C++ programs.
      uses: jidicula/clang-format-action@v3.2.0
      with:
        clang-format-version: '11'
        check-path: 'src'
```

# Who uses this?

Click [here](https://github.com/search?q=uses%3A+jidicula%2Fclang-format-action+-user%3Ajidicula&type=Code) to see the public repos using this Action.
