#!/usr/bin/env bash

###############################################################################
#                           format-diff-old.sh                                #
###############################################################################
# Helper for clang-format versions below 10 that lack --dry-run.
# Runs inside a Docker container. Formats each file and compares the output
# to the original. Prints FAILED:<filepath> to stderr for any file that
# differs from the clang-format output.
#
# USAGE: ./format-diff-old.sh <fallback-style> <file1> [<file2> ...]

exit_code=0
fallback="$1"
shift

for file in "$@"; do
	formatted="$(clang-format --style=file --fallback-style="$fallback" "$file")"
	if ! diff -q "$file" <(printf '%s\n' "$formatted") >/dev/null 2>&1; then
		echo "FAILED:$file" >&2
		exit_code=1
	fi
done

exit $exit_code
