[![ubuntu-20.04 Tests](https://github.com/jidicula/clang-format-action/actions/workflows/test-ubuntu-20.04.yml/badge.svg)](https://github.com/jidicula/clang-format-action/actions/workflows/test-ubuntu-20.04.yml) [![ubuntu-22.04 Tests](https://github.com/jidicula/clang-format-action/actions/workflows/test-ubuntu-22.04.yml/badge.svg)](https://github.com/jidicula/clang-format-action/actions/workflows/test-ubuntu-22.04.yml)

[![shell-lint](https://github.com/jidicula/clang-format-action/workflows/shell-lint/badge.svg?branch=main)](https://github.com/jidicula/clang-format-action/actions?query=workflow%3Ashell-lint+branch%3Amain)


# clang-format-action
GitHub Action for `clang-format` checks. Note that this Action does **NOT** format your code for you - it only verifies that your repository's code follows your project's formatting conventions.

You can define your own formatting rules in a `.clang-format` file at your repository root, or you can provide a fallback style (see [`fallback-style`](#inputs)). You can also provide a path to check. If you want to run checks against multiple paths in your repository, you can use this Action in a [matrix run](#multiple-paths).

## Major versions supported
* 3: `clang-format-3.9`
* 4: `clang-format-4.0`
* 5: `clang-format-5.0`
* 6: `clang-format-6.0`
* 7: `clang-format-7`
* 8: `clang-format-8`
* 9: `clang-format-9`
* 10: `clang-format-10`
* 11:  `clang-format-11`
* 12: `clang-format-12`
* 13: `clang-format-13`
* 14: `clang-format-14`
* 15: `clang-format-15`
* 16: `clang-format-16`

## Do you find this useful?

You can sponsor me [here](https://github.com/sponsors/jidicula)!

## Inputs
* `clang-format-version` [optional]: The major version of `clang-format` that you want to run on your codebase.
  * Default: `13`
  * Available versions: see [Versions supported](#versions-supported)
* `check-path` [optional]: The path to the directory in the repo that should be checked for C/C++/Protobuf formatting.
  * Default: `.`
  * For cleaner output (i.e. with no double-slashed paths), the final directory in this path should have no trailing slash, e.g. `src` and not `src/`.
* `fallback-style` [optional]: The fallback style for `clang-format` if no `.clang-format` file exists in your repository.
  * Default: `llvm`
  * Available values: `LLVM`, `Google`, `Chromium`, `Mozilla`, `WebKit` and others listed in the `clang-format` [docs for BasedOnStyle](https://clang.llvm.org/docs/ClangFormatStyleOptions.html#configurable-format-style-options).
* `exclude-regex` [optional]: A regex to exclude files or directories that should not be checked.
  * Default: `^$`
  * Pattern matching is done with a POSIX `grep -E` extended regex, **not** a glob expression. You can exclude multiple patterns like this: `(hello|world)`. Build and verify your regex at https://regex101.com .
* `include-regex` [optional]: A regex to include files or directories that should be checked.
  * Default: `^.*\.((((c|C)(c|pp|xx|\+\+)?$)|((h|H)h?(pp|xx|\+\+)?$))|(ino|pde|proto|cu))$`
  * Pattern matching is done with a POSIX `grep -E` extended regex, **not** a glob expression. You can exclude multiple patterns like this: `(hello|world)`. Build and verify your regex at https://regex101.com .

This action checks all C/C++/Protobuf (including Arduino `.ino` and `.pde`) files in the provided directory in the GitHub workspace are formatted correctly using `clang-format`. If no directory is provided or the provided path is not a directory in the GitHub workspace, all C/C++/Protobuf files are checked.

The following file extensions are checked by default:
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
  * `.ino`
  * `.pde`
  * `.cu`
* Protobuf files:
  * `.proto`

## Returns:

* SUCCESS: zero exit-code if C/C++/Protobuf files in `check-path` are formatted correctly
* FAILURE: nonzero exit-code if C/C++/Protobuf files in `check-path` are not formatted correctly

# Usage

⚠️This action does not run on `windows` GitHub Actions runners!

## Single Path

To use this action, create a `.github/workflows/clang-format-check.yml` in your repository containing:

```yaml
name: clang-format Check
on: [push, pull_request]
jobs:
  formatting-check:
    name: Formatting Check
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3
    - name: Run clang-format style check for C/C++/Protobuf programs.
      uses: jidicula/clang-format-action@v4.11.0
      with:
        clang-format-version: '13'
        check-path: 'src'
        fallback-style: 'Mozilla' # optional
```

## Multiple Paths
To use this action on multiple paths in parallel, create a `.github/workflows/clang-format-check.yml` in your repository containing:

```yaml
name: clang-format Check
on: [push, pull_request]
jobs:
  formatting-check:
    name: Formatting Check
    runs-on: ubuntu-latest
    strategy:
      matrix:
        path:
          - 'src'
          - 'examples'
    steps:
    - uses: actions/checkout@v3
    - name: Run clang-format style check for C/C++/Protobuf programs.
      uses: jidicula/clang-format-action@v4.11.0
      with:
        clang-format-version: '13'
        check-path: ${{ matrix.path }}
        fallback-style: 'Mozilla' # optional
```

## Multiple Paths with Exclusion Regexes
To use this action on multiple paths in parallel with exclusions, create a `.github/workflows/clang-format-check.yml` in your repository containing:

```yaml
name: clang-format Check
on: [push, pull_request]
jobs:
  formatting-check:
    name: Formatting Check
    runs-on: ubuntu-latest
    strategy:
      matrix:
        path:
          - check: 'src'
            exclude: '(hello|world)' # Exclude file paths containing "hello" or "world"
          - check: 'examples'
            exclude: ''              # Nothing to exclude
    steps:
    - uses: actions/checkout@v3
    - name: Run clang-format style check for C/C++/Protobuf programs.
      uses: jidicula/clang-format-action@v4.11.0
      with:
        clang-format-version: '13'
        check-path: ${{ matrix.path['check'] }}
        exclude-regex: ${{ matrix.path['exclude'] }}
        fallback-style: 'Mozilla' # optional
```

# Who uses this?

[These public repos](https://github.com/search?o=desc&q=uses%3A+jidicula%2Fclang-format-action+-user%3Ajidicula&s=indexed&type=Code) use this Action.
