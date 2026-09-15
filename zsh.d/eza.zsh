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

alias lli='ll --git-ignore'
alias lld='ll --only-dirs'
alias llf='ll --only-files'
alias ll.='ll -d .?*'
