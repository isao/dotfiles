#!/bin/bash
set -eo pipefail

# Run `ctags` recursively from a project root directory. The path is obtained,
# in order of priority, from: the first command line argument, the BB_DOC_PATH
# environment variable, or the current working directory. Must also be in a git
# repository (see `show-package-toplevel.sh`).
#
# If the project's directory name matches a sub-directory in `~/config/ctags/`,
# then ctags config files there will be pre-loaded.
#

function err() {
    echo "$2" >&2
    exit "$1"
}

function alert() {
    osascript -e "display notification \"$1 indexed.\" with title \"$2\""
}

# Main.
#

# Set path to find the project directory to index with ctags.
# Use $1, $BB_DOC_PATH (if launched from BBEdit), or $PWD in that order.
path="${1:-${BB_DOC_PATH:-$PWD}}"

# This script, which is next to `show-package-toplevel.sh`.
self_dir="$(dirname "$(realpath "$0")")"
self_name="$(basename "$0" .sh)"

# Get the directory path and name of the nearest package (directory with a
# "package.json" or is a git root) from the current working directory.
package_path="$("$self_dir/show-package-toplevel.sh" "$path")"
package_name="$(basename "$package_path")"

# Generate ctags from the package's top-level directory.
ctags --options-maybe="$package_name" --recurse "$package_path" &
alert "$package_name" "$self_name"
