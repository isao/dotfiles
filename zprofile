# This file is sourced by login shells, including shells launched by GUI apps.
# https://www.barebones.com/support/bbedit/zshenv.html
# shellcheck disable=SC2206,SC2128
# Disable reason: `path` is not subject to the bash-specific warnings above.

# Prepends Homebrew's bin and sbin to $PATH, and exports $HOMEBREW_PREFIX,
# $HOMEBREW_CELLAR and $HOMEBREW_REPOSITORY
whence brew >/dev/null && eval "$(brew shellenv zsh)"

# Appends to $PATH (before `volta`)
path=($path ./node_modules/.bin "$HOME/.local/bin")

# Appends to $PATH.
whence volta >/dev/null && path=($path "$HOME/.volta/bin")
