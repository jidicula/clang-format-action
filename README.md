[![Docker Image CI](https://github.com/jidicula/clang-format-action/workflows/Docker%20Image%20CI/badge.svg?branch=main)](https://github.com/jidicula/clang-format-action/actions?query=workflow%3A%22Docker+Image+CI%22+branch%3Amain) [![shell-lint](https://github.com/jidicula/clang-format-action/workflows/shell-lint/badge.svg?branch=main)](https://github.com/jidicula/clang-format-action/actions?query=workflow%3Ashell-lint+branch%3Amain)

# clang-format-action
GitHub Action for clang-format checks. Note that this Action does **NOT** format your code for you - it only verifies that your repository's code follows your project's formatting conventions.

You can define your own formatting rules in a `.clang-format` file at your repository root, or you can provide a fallback style (see [`fallback-style`](#inputs)). You can also provide a path to check. If you want to run checks against multiple paths in your repository, you can use this Action in a [matrix run](#multiple-paths).

## Do you find this useful?

You can sponsor me [here](https://github.com/sponsors/jidicula)!

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
* `exclude-regex` [optional]: A regex to exclude files or directories that should not be checked.
  * Default: `^$`
  * Pattern matching is done with a real regex, not a glob expression. You can exclude multiple patterns like this: `(hello|world)`.

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

# Usage

## Single Path

To use this action, create a `.github/workflows/clang-format-check.yml` in your repository containing:

```yaml
name: clang-format Check
on: [push, PR]
jobs:
  formatting-check:
    name: Formatting Check
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
    - name: Run clang-format style check for C/C++ programs.
      uses: jidicula/clang-format-action@v3.3.0
      with:
        clang-format-version: '11'
        check-path: 'src'
        fallback-style: 'Mozilla' # optional
```

## Multiple Paths
To use this action on multiple paths in parallel, create a `.github/workflows/clang-format-check.yml` in your repository containing:

```yaml
name: clang-format Check
on: [push, PR]
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
    - uses: actions/checkout@v2
    - name: Run clang-format style check for C/C++ programs.
      uses: jidicula/clang-format-action@v3.3.0
      with:
        clang-format-version: '11'
        check-path: ${{ matrix.path }}
        fallback-style: 'Mozilla' # optional
```

## Multiple Paths with Exclusion Regexes
To use this action on multiple paths in parallel with exclusions, create a `.github/workflows/clang-format-check.yml` in your repository containing:

```yaml
name: clang-format Check
on: [push, PR]
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
    - uses: actions/checkout@v2
    - name: Run clang-format style check for C/C++ programs.
      uses: jidicula/clang-format-action@v3.3.0
      with:
        clang-format-version: '11'
        check-path: ${{ matrix.path['check'] }}
        exclude-regex: ${{ matrix.path['exclude'] }}
        fallback-style: 'Mozilla' # optional
```

# Who uses this?

[These public repos](https://github.com/search?o=desc&q=uses%3A+jidicula%2Fclang-format-action+-user%3Ajidicula&s=indexed&type=Code) use this Action.
