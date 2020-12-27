| Branch | Docker Image CI | shellcheck | shfmt |
|--------|-----------------|------------|-------|
| `main`   | ![Docker Image CI](https://github.com/jidicula/clang-format-action/workflows/Docker%20Image%20CI/badge.svg?branch=main) | ![shellcheck](https://github.com/jidicula/clang-format-action/workflows/shellcheck/badge.svg?branch=main) | ![shfmt](https://github.com/jidicula/clang-format-action/workflows/shfmt/badge.svg?branch=main) |
| `dev`    | ![Docker Image CI](https://github.com/jidicula/clang-format-action/workflows/Docker%20Image%20CI/badge.svg?branch=dev) | ![shellcheck](https://github.com/jidicula/clang-format-action/workflows/shellcheck/badge.svg?branch=dev) | ![shfmt](https://github.com/jidicula/clang-format-action/workflows/shfmt/badge.svg?branch=dev) |

# clang-format-action
GitHub Action for clang-format

This action checks all C/C++ files in the GitHub workspace are formatted correctly using `clang-format`.

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

The action returns:

* SUCCESS: zero exit-code if project C/C++ files are formatted correctly
* FAILURE: nonzero exit-code if project C/C++ files are not formatted correctly

Define your own formatting rules in a `.clang-format` file at your repository root. Otherwise, the LLVM style guide is used as a default. My preference is the [Linux Project format](https://github.com/torvalds/linux/blob/master/.clang-format).

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
      uses: jidicula/clang-format-action@v2.0.0
```
