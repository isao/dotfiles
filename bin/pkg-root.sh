#!/bin/bash -ex

git_repo_root_dir() {
    git rev-parse --show-toplevel 2>/dev/null
}

is_package_root() {
    [ -f package.json ] || [ -d .git ]
}

# `cd` up until we hit a `package.json` or `.git` dir.
package_root_dir() {(
    local lastPwd
    while ! is_package_root && [ "$lastPwd" != "$PWD" ]
    do
        lastPwd="$PWD"
        cd ..
    done
    is_package_root && pwd
)}

# Use arg as starting point, if applicable.
[[ -d "$1" ]] && cd "$1"

package_root_dir
