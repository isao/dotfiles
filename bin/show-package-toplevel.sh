#!/usr/bin/env bash
set -euo pipefail

# Given a path (defaulting to the the current working directory), find the
# nearest parent directory that has a `package.json` file, or is the top level
# of a git repo.
#

error() {
    echo "$2" >&2
    exit "$1"
}

# Init.
#
path="${1:-$PWD}"
[ -f "$path" ] && path=$(dirname "$path")

git_root=$(git -C "$path" rev-parse --show-toplevel 2>/dev/null || true)

# Safety checks.
#
[ "$HOME" = "/" ] && error 1 "Refusing to run when \$HOME is '/'."

[[ "$path" != "$HOME"/* ]] && error 2 "Path '$path' is outside \$HOME."

[ -z "$git_root" ] && error 3 "Path '$path' is outside a git repository."

# Main.
#
while [ "$path" != "$HOME" ]
do
    if [[ -f "$path/package.json" || "$path" = "$git_root" ]]
    then
        # Found the nearest top-level package or git repo directory.
        echo "$path"
        exit 0
    fi
    path=$(dirname "$path")
done

error 4 "No package.json or git root found."
