#!/usr/bin/env bash

###############################################################################
#                                entrypoint.sh                                #
###############################################################################
# Checks all C/C++ files (.h, .H, .hpp, .hh, .h++, .hxx and .c, .C, .cpp, .cc,
# .c++, .cxx) in the provided GitHub repository path for conforming to
# clang-format. If no path is provided or provided path is not a directory, all
# C/C++ files are checked. If any C files are incorrectly formatted, the script
# lists them and exits with 1.
#
# Define your own formatting rules in a .clang-format file at your repository
# root. Otherwise, the LLVM style guide is used as a default.

# format_diff function
# Accepts a filepath argument. The filepath passed to this function must point
# to a C/C++ file. The file is formatted with clang-format and that output is
# compared to the original file.
format_diff() {
	local filepath="$1"
	local_format="$(/usr/bin/clang-format-"$CLANG_FORMAT_VERSION" -n --Werror --style=file --fallback-style=LLVM "${filepath}")"
	local format_status="$?"
	if [[ "${format_status}" -ne 0 ]]; then
		echo "$local_format" >&2
		exit_code=1
		return "${format_status}"
	fi
	return 0
}

CHECK_PATH="$1"

# Install clang-format
echo "Installing clang-format-$CLANG_FORMAT_VERSION"
apt-get update && apt-get install -y --no-install-recommends clang-format-"$CLANG_FORMAT_VERSION"

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
	format_diff "${file}"
done

exit "$exit_code"
