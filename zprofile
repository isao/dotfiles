# PATH configuration for both terminal and GUI applications
# This file is sourced by login shells, including shells launched by GUI apps

# shellcheck disable=SC2206,SC2128
# Disable reason: `path` is not subject to the bash-specific warnings above.

# Prepend homebrew to PATH (highest priority)
path=(/opt/homebrew/bin $path)

# Append volta to PATH (lowest priority), if installed via `brew` or in `path`.
whence volta >/dev/null && path=($path "$HOME/.volta/bin")
