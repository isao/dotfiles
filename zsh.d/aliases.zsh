#
# built-ins
#

alias cd..='cd ..'
alias ls=' ls -FG'
alias ll=' /bin/ls -lFG'
alias lsd='find . -type d -depth 1 | xargs ls -dl "{}" \;'  # ll dirs only
alias ls.='ls -dFG .?*'  # ls dot files & dirs only
alias ll.='ls -dFGl .?*'  # ls dot files & dirs only
alias la='ll -A'


# git
gg() {
    git stash list
    git status --branch --short $@
}

ggg() {
    gg --ignored $@
}

# alias gg='git status --branch --short \!* && git stash list'
# alias ggg='git status --branch --short --ignored \!* && git stash list'

alias gb 'git branch | grep -v old/'
alias gd 'git difftool'
alias gu 'git gui browser'
alias gsl 'git stash list'
alias gss 'git stash save'
alias gr 'git remote'

# osx

#remove style from any text on the clipboard
alias plaintext='pbpaste -Prefer txt | pbcopy'

#cd to finder cwd
#if(-f $shellrepo/cwdfinder.applescript)
alias cwdfinder='cd -p "$(osascript ~/repos/shell/cwdfinder.applescript)"'

#cd to dir of front bbedit text document
alias cwdbbedit='cd -p "$(osascript ~/repos/shell/cwdbbedit.applescript)"'
