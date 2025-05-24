# https://dandavison.github.io/delta/grep.html
rgdelta() {
    rg --json -C 2 $@ | delta
}

# Display `ripgrep` search results in `fzf`, with preview, open selected in BBEdit.
# rgfzf() {
#     rg --files-with-matches "$@" \
#         | fzf --preview "echo \"$1\" found in {}:; rg --color=always -C6 \"$1\" {}" --preview-window '~1' --print0 \
#         | xargs -0 bbedit
# }

# Display `ripgrep` search results in `fzf` that update live.
# Copied from <https://github.com/junegunn/fzf/blob/master/ADVANCED.md#switching-between-ripgrep-mode-and-fzf-mode>
# Changed vim -> bbedit
rgfzf() {
    rm -f /tmp/rg-fzf-{r,f}
    RG_PREFIX="rg --column --line-number --no-heading --color=always --smart-case "
    INITIAL_QUERY="${*:-}"
    FZF_DEFAULT_COMMAND="$RG_PREFIX $(printf %q "$INITIAL_QUERY")" \
    fzf --ansi \
        --color "hl:-1:underline,hl+:-1:underline:reverse" \
        --disabled --query "$INITIAL_QUERY" \
        --bind "change:reload:sleep 0.1; $RG_PREFIX {q} || true" \
        --bind "ctrl-f:unbind(change,ctrl-f)+change-prompt(2. fzf> )+enable-search+rebind(ctrl-r)+transform-query(echo {q} > /tmp/rg-fzf-r; cat /tmp/rg-fzf-f)" \
        --bind "ctrl-r:unbind(ctrl-r)+change-prompt(1. ripgrep> )+disable-search+reload($RG_PREFIX {q} || true)+rebind(change,ctrl-f)+transform-query(echo {q} > /tmp/rg-fzf-f; cat /tmp/rg-fzf-r)" \
        --bind "start:unbind(ctrl-r)" \
        --prompt '1. ripgrep> ' \
        --delimiter : \
        --header '╱ CTRL-R (ripgrep mode) ╱ CTRL-F (fzf mode) ╱' \
        --preview 'moar {1}' \
        --preview-window 'up,40%,border-bottom,+{2}+3/3,~3' \
        --bind 'enter:become(bbedit {1} +{2})'
}

