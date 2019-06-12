type bbedit >/dev/null || return

compdef _gnu_generic bbedit bbdiff bbfind bbresults

# Open files with the following extension in BBEdit.
alias -s bbprojectd=bbedit
alias -s hbs=bbedit
alias -s html=bbedit
alias -s json=bbedit
alias -s less=bbedit
alias -s scss=bbedit
alias -s ts=bbedit

bbproj() {
    mdfind kMDItemContentType:com.barebones.bbedit.project | fzf | xargs open
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
    cd -P "$(dirname "$(bbpath)")"
}

rgbb() {
    rg -n $@ | bbresults
}
