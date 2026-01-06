# This file is sourced by login shells, including shells launched by GUI apps.
# https://www.barebones.com/support/bbedit/zshenv.html
# shellcheck disable=SC2206,SC2128
# Disable reason: `path` is not subject to the bash-specific warnings above.

path=(/opt/homebrew/bin $path ./node_modules/.bin)

whence volta >/dev/null && path=($path "$HOME/.volta/bin")
