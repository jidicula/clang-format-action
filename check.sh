#!/usr/bin/env bash

###############################################################################
#                                check.sh                                     #
###############################################################################
# USAGE: ./check.sh [<clang-format version>] [<path>] [<fallback style>]
#                    [<exclude regex>] [<include regex>]
#
# Checks all C/C++/Protobuf/CUDA files (.h, .H, .hpp, .hh, .h++, .hxx and .c,
# .C, .cpp, .cc, .c++, .cxx, .proto, .cu) in the provided GitHub repository path
# (arg2) for conforming to clang-format. If no path is provided or provided path
# is not a directory, all C/C++/Protobuf/CUDA files are checked. If any files
# are incorrectly formatted, the script lists them and exits with 1.
#
# Define your own formatting rules in a .clang-format file at your repository
# root. Otherwise, the provided style guide (arg3) is used as a fallback.

CLANG_FORMAT_MAJOR_VERSION="$1"
CHECK_PATH="$2"
FALLBACK_STYLE="$3"
EXCLUDE_REGEX="$4"
INCLUDE_REGEX="$5"

# Set the regex to an empty string regex if nothing was provided
if [[ -z $EXCLUDE_REGEX ]]; then
	EXCLUDE_REGEX="^$"
fi

# Set the filetype regex if nothing was provided.
# Find all C/C++/Protobuf/CUDA files:
#   h, H, hpp, hh, h++, hxx
#   c, C, cpp, cc, c++, cxx
#   ino, pde
#   proto
#   cu
if [[ -z $INCLUDE_REGEX ]]; then
	INCLUDE_REGEX='^.*\.((((c|C)(c|pp|xx|\+\+)?$)|((h|H)h?(pp|xx|\+\+)?$))|(ino|pde|proto|cu))$'
fi

cd "$GITHUB_WORKSPACE" || exit 2

if [[ ! -d $CHECK_PATH ]]; then
	echo "Not a directory in the workspace, fallback to all files." >&2
	CHECK_PATH="."
fi

# initialize exit code
exit_code=0

DOCKER_IMAGE="ghcr.io/jidicula/clang-format:${CLANG_FORMAT_MAJOR_VERSION}"

# output clang-format version
docker run \
	--volume "$(pwd)":"$(pwd)" \
	--workdir "$(pwd)" \
	"$DOCKER_IMAGE" --version

# All files improperly formatted will be printed to the output.
src_files=$(find "$CHECK_PATH" -name .git -prune -o -regextype posix-egrep -regex "$INCLUDE_REGEX" -print)

# Build array of files to check, applying the exclude regex.
files_to_check=()
IFS=$'\n'
for file in $src_files; do
	if ! [[ ${file} =~ $EXCLUDE_REGEX ]]; then
		files_to_check+=("$file")
	fi
done
unset IFS

if [[ ${#files_to_check[@]} -eq 0 ]]; then
	echo "No source files to check."
	exit 0
fi

# Run clang-format on all files in a single Docker invocation.
if [[ $CLANG_FORMAT_MAJOR_VERSION -gt "9" ]]; then
	# clang-format >= 10 supports --dry-run --Werror, which outputs
	# diagnostics for incorrectly formatted files and exits non-zero.
	format_output="$(docker run \
		--volume "$(pwd)":"$(pwd)" \
		--workdir "$(pwd)" \
		"$DOCKER_IMAGE" \
		--dry-run \
		--Werror \
		--style=file \
		--fallback-style="$FALLBACK_STYLE" \
		"${files_to_check[@]}" 2>&1)"
	format_status="$?"

	if [[ ${format_status} -ne 0 ]]; then
		exit_code=1
		# Extract unique failing file paths from diagnostics.
		# Output lines look like: ./path/file.c:10:5: error: ...
		while IFS= read -r failing_file; do
			echo "* \`$failing_file\`" >>failing-files.txt
			echo "Failed on file: $failing_file" >&2
		done < <(echo "$format_output" | sed -n 's/\(.*\):[0-9][0-9]*:[0-9][0-9]*:.*$/\1/p' | sort -u)
		echo "$format_output" >&2
	fi
else
	# Versions below 10 don't have --dry-run; mount a helper script into
	# the container that formats each file and compares it to the original.
	SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
	format_output="$(docker run \
		--volume "$(pwd)":"$(pwd)" \
		--volume "$SCRIPT_DIR/format-diff.sh":/format-diff.sh:ro \
		--workdir "$(pwd)" \
		--entrypoint /bin/bash \
		"$DOCKER_IMAGE" \
		/format-diff.sh "$FALLBACK_STYLE" "${files_to_check[@]}" 2>&1)"
	format_status="$?"

	if [[ ${format_status} -ne 0 ]]; then
		exit_code=1
		while IFS= read -r line; do
			if [[ "$line" == FAILED:* ]]; then
				file="${line#FAILED:}"
				echo "* \`$file\`" >>failing-files.txt
				echo "Failed on file: $file" >&2
			fi
		done <<<"$format_output"
	fi
fi

# Global exit code is nonzero if any files are incorrectly formatted.
exit "$exit_code"
