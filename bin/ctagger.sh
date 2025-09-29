#!/bin/bash
set -eo pipefail

# Run `ctags` recursively from the project root directory.
#
# If the project's directory name matches a sub-directory in ~/config/ctags/
# then ctags config files there will be pre-loaded.

function err() {
    echo "$2" >&2
    exit "$1"
}

function alert() {
    osascript -e "display notification \"$1 indexed.\" with title \"$2\""
}

# Set path to find the project directory to index with ctags.
# Use $1, $BB_DOC_PATH (if launched from BBEdit), or $PWD in that order.
path="${1:-${BB_DOC_PATH:-$PWD}}"

# This script, which is next to `show-package-toplevel.sh`.
self_dir="$(dirname "$(realpath "$0")")"
self_name="$(basename "$0" .sh)"

# Get the path and basename of the nearest package (directory with a
# "package.json" or is a git root) from the current working directory.
package_path="$("$self_dir/show-package-toplevel.sh" "$path")"
package_name="$(basename "$package_path")"

# Generate ctags from the package's top-level directory.
ctags -R "$package_path" --options-maybe="$package_name" "$@"
alert "$package_name" "$self_name"
