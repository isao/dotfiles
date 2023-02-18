# shellcheck shell=bash
whence bbedit >/dev/null || return

compdef _gnu_generic bbedit bbdiff bbfind bbresults

# Open files with the following extension in BBEdit.
alias -s bbprojectd=bbedit
alias -s html=bbedit
alias -s js=bbedit
alias -s json=bbedit
alias -s less=bbedit
alias -s scss=bbedit
alias -s ts=bbedit

alias -s hbs=bbedit
alias -s svelte=bbedit
alias -s vue=bbedit

bbproj() {
    mdfind kMDItemContentType:com.barebones.bbedit.project \
    | fzf --print0 \
    | xargs -0 open
}

bbf() {
    bbfind --grep --gui "$@"
}

bbpath() {
    osascript <<-EOF
    tell application "BBEdit"
        if the first text document exists then
            file of first text document as alias
            POSIX path of result
        else
            beep
        end if
    end tell
EOF
}

cdbbedit() {
    cd -P "$(dirname "$(bbpath)")" || exit 1
}

fzfbb() {
    fzf | xargs bbedit
}

# Display `ripgrep` search results in a BBEdit results window.
rgbb() {
    # Note: --pattern specifies "\s*", instead of the default "\s+"
    rg --column --line-number "$@" \
        | bbresults --pattern '^(?P<file>.+?):(?P<line>\d+):(?P<col>\d+):\s*(?P<msg>.*)$'
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
        --preview 'bat --color=always {1} --highlight-line {2}' \
        --preview-window 'up,40%,border-bottom,+{2}+3/3,~3' \
        --bind 'enter:become(bbedit {1} +{2})'
}

# Find in notes
fin() {
    (cd ~/notes && rgfzf "$1")
}

# Display `shellcheck` feedback in a BBEdit results window.
shellcheckbb() {
    shellcheck -f gcc "$@" | bbresults --pattern gcc
}
