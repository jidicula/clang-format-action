#!/usr/bin/env bash

###############################################################################
#                                entrypoint.sh                                #
###############################################################################
# USAGE: ./entrypoint.sh [<path>] [<fallback style>]
# Checks all C/C++ files (.h, .H, .hpp, .hh, .h++, .hxx and .c, .C, .cpp, .cc,
# .c++, .cxx) in the provided GitHub repository path (arg1) for conforming to
# clang-format. If no path is provided or provided path is not a directory, all
# C/C++ files are checked. If any C files are incorrectly formatted, the script
# lists them and exits with 1.
#
# Define your own formatting rules in a .clang-format file at your repository
# root. Otherwise, the provided style guide (arg2) is used as a fallback.

# format_diff function
# Accepts a filepath argument. The filepath passed to this function must point
# to a C/C++ file. The file is formatted with clang-format and that output is
# compared to the original file.
format_diff() {
	local filepath="$1"
	local_format="$(/usr/bin/clang-format-"$CLANG_FORMAT_VERSION" -n --Werror --style=file --fallback-style="$FALLBACK_STYLE" "${filepath}")"
	local format_status="$?"
	if [[ "${format_status}" -ne 0 ]]; then
		echo "Failed on file: $filepath"
		echo "$local_format" >&2
		exit_code=1
		return "${format_status}"
	fi
	return 0
}

CHECK_PATH="$1"
FALLBACK_STYLE="$2"
EXCLUDE_REGEX="$3"

# Set the regex to an empty string regex if nothing was provided
if [ -z "$EXCLUDE_REGEX" ]; then
	EXCLUDE_REGEX="^$"
fi

# Install clang-format
echo "Installing clang-format-$CLANG_FORMAT_VERSION"

# Need to purge libappstream3 to address a bug in Ubuntu Impish
apt-get update && apt-get purge libappstream3 && apt-get install -y --no-install-recommends clang-format-"$CLANG_FORMAT_VERSION"

cd "$GITHUB_WORKSPACE" || exit 2

if [[ ! -d "$CHECK_PATH" ]]; then
	echo "Not a directory in the workspace, fallback to all files."
	CHECK_PATH="."
fi

# initialize exit code
exit_code=0

# All files improperly formatted will be printed to the output.
# find all C/C++ files:
#   h, H, hpp, hh, h++, hxx
#   c, C, cpp, cc, c++, cxx
c_files=$(find "$CHECK_PATH" | grep -E '\.((c|C)c?(pp|xx|\+\+)*$|(h|H)h?(pp|xx|\+\+)*$)')

# check formatting in each C file
for file in $c_files; do
	# Only check formatting if the path doesn't match the regex
	if ! [[ "${file}" =~ $EXCLUDE_REGEX ]]; then
		format_diff "${file}"
	fi
done

exit "$exit_code"
