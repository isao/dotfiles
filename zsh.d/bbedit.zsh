# shellcheck shell=bash
whence bbedit >/dev/null || return

compdef _gnu_generic bbedit bbdiff bbfind bbresults

# Open files with the following extension in BBEdit.
alias -s bbprojectd=bbedit
alias -s cjs=bbedit
alias -s hbs=bbedit
alias -s html=bbedit
alias -s js=bbedit
alias -s json=bbedit
alias -s less=bbedit
alias -s mjs=bbedit
alias -s scss=bbedit
alias -s svelte=bbedit
alias -s ts=bbedit
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

# Find a ctag symbol, and open it w/ bbedit.
# % readtags Page
# Page	src/environment/view-model/page/Page.ts	12
#
# % readtags Page | awk '{ print $2 ":" $3 }'
# src/environment/view-model/page/Page.ts:12
#
bbtag() {
    local f
    f=$(readtags $1 | head -1 | awk '{ print $2 ":" $3 }')
    if [[ -n "$f" ]]
    then
        bbedit "$f"
    else
        echo "Symbol \"$1\" not found. Re-index?" >&2
    fi
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

# Find in notes
fin() {
    (cd ~/notes && rgfzf "$1")
}

# Display `shellcheck` feedback in a BBEdit results window.
shellcheckbb() {
    shellcheck -f gcc "$@" | bbresults --pattern gcc
}

# Show `tsc` errors in a BBEdit results browser.
tscbb() {
    tsc --noEmit --pretty false "$@" \
        | bbresults -p '^(?P<file>.+?)\((?P<line>\d+),(?P<col>\d+)\): (?P<type>\w+) (?P<msg>.+)'
}
