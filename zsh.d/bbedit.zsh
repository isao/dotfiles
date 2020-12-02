# shellcheck shell=bash

whence bbedit >/dev/null || return

compdef _gnu_generic bbedit bbdiff bbfind bbresults

# Open files with the following extension in BBEdit.
alias -s bbprojectd=bbedit
alias -s hbs=bbedit
alias -s html=bbedit
alias -s js=bbedit
alias -s json=bbedit
alias -s less=bbedit
alias -s scss=bbedit
alias -s ts=bbedit

bbproj() {
    mdfind kMDItemContentType:com.barebones.bbedit.project \
    | fzf --print0 \
    | xargs -0 open
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

rgbb() {
    # Note: --pattern specifies "\s*", instead of the default "\s+"
    # shellcheck disable=SC2068
    rg --column --line-number $@ \
        | bbresults --pattern '(?P<file>.+?):(?P<line>\d+):((?P<col>\d+):)\s*(?P<msg>.*)$'
}

shellcheckbb() {
    # shellcheck disable=SC2068
    shellcheck -f gcc $@ | bbresults
}

fzfbb() {
    fzf | xargs bbedit
}
