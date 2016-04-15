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

#
# one-liners
#

alias grep='grep --color=auto'
alias nocolors="perl -pe 's/\e\[?.*?[\@-~]//g'"
alias rot13='perl -wne "tr/a-zA-Z/n-za-mN-ZA-M/;print;"'
alias showenv='env | sort'
alias showpath='echo $PATH | tr : "\n"'
alias checkpath='ls -ld $(echo $PATH | tr : "\n") > /dev/null'


# git
alias gg='git status --branch --short'
alias ggg='gg --ignored'
alias gb='git branch | grep -v old/'
alias gd='git difftool'
alias gu='git gui browser'
alias gr='git remote -v'
alias gsl='git stash list'
alias gsv='git stash save'
alias gss='git stash show'

# osx

#remove style from any text on the clipboard
alias plaintext='pbpaste -Prefer txt | pbcopy'

#cd to finder cwd
#if(-f $shellrepo/cwdfinder.applescript)
alias cwdfinder='cd -p "$(osascript ~/repos/shell/cwdfinder.applescript)"'

#cd to dir of front bbedit text document
alias cwdbbedit='cd -p "$(osascript ~/repos/shell/cwdbbedit.applescript)"'
