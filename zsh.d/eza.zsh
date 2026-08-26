whence eza >/dev/null || return

export EZA_CONFIG_DIR="$HOME/.config/eza"

alias ll='eza -l \
    --git \
    --git-repos-no-status \
    --group-directories-first \
    --hyperlink \
    --icons \
    --mounts \
    --time-style=relative'

alias lld='ll --only-dirs'
alias ll.='ll -d .?*'
