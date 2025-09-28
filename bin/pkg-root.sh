#!/usr/bin/env bash
set -euo pipefail

# From the current working directory, find the nearest parent directory
# containing either a `package.json` file, or the top level of a git repo.

error() {
    echo "$2" >&2
    exit $1
}

path="$PWD"

# Safety checks
if [ "$path" = "/" ] || [ "$HOME" = "/" ]
then
    error 1 "Refusing to run with / as path or HOME"
fi

if [[ "$path" != "$HOME"/* ]]
then
    error 2 "Path is outside \$HOME: $path"
fi

# Require git root
git_root=$(git -C "$path" rev-parse --show-toplevel 2>/dev/null || true)
if [ -z "$git_root" ]
then
    error 3 "Not inside a git repository: $path"
fi

# Traverse upwards until $HOME (exclusive)
while [ "$path" != "$HOME" ]; do
    if [[ -f "$path/package.json" || "$path" = "$git_root" ]]
    then
        echo "$path"
        exit 0
    fi
    path=$(dirname "$path")
done

error 4 "No package.json or git root found up to \$HOME"
