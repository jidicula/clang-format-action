# Testing your contribution:

You can clone [jidicula/test-clang-format-action](https://github.com/jidicula/test-clang-format-action) and modify the GitHub Actions workflow to point to your clone and your branch:
e.g.

```yaml
name: clang-format Check
on:
  push:
  workflow_dispatch:
jobs:
  formatting-check:
    name: Formatting Check
    strategy:
      matrix:
        path:
          - check: 'known_fail'
            exclude: 'capi'
          - check: 'known_pass'
            exclude: 'capi'
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
    - name: Run clang-format style check for C/C++ programs.
      uses: yourusername/clang-format-action@your-branch-name # modify this to point to your fork and feature branch!
      with:
        check-path: ${{ matrix.path['check'] }}
        clang-format-version: 11
        exclude-regex: ${{ matrix.path['exclude'] }}
```

Then you can set up test cases as needed in the test repo, and work on your patch in your clone of `clang-format-action` - each time you want to re-run your test workflow, you can use the workflow dispatch trigger.

Alternatively, you can modify your own repo that you intend to use with this Action to point to your fork and feature branch to make sure it works well.
