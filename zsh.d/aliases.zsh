#
# built-ins
#

alias cd..='cd ..'
alias ls='ls -FG'
alias ll='/bin/ls -lG'
alias kk=ll
alias ls.='ls -dG .?*'  # ls dot files & dirs only
alias ll.='ls -dGl .?*' # ls dot files & dirs only
alias la='ll -A'
#alias lsd='find . -type d -depth 1 | xargs ls -dl "{}" \;'  # ll dirs only
alias lsd='/bin/ls -d */'   # ls just directories
alias llsd='/bin/ls -dl */' # ll just directories

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
alias gb='git branch -v | egrep -v "^. old/" | cut -c 1-$(tput cols)'
alias gd='git difftool'
alias gf='git fetch -p'
alias gp='git pull -p --ff-only'
alias gu='git gui browser'
alias gr='git remote -v'
alias gsa='git stash apply'
alias gsd='git stash drop'
alias gsl='git stash list'
alias gsv='git stash save'
alias gss='git stash show'

#tig
alias tgs='tig status'
alias tgl='tig log'
alias tgb='tig blame -w -C'

# osx

#remove style from any text on the clipboard
alias plaintext='pbpaste -Prefer txt | pbcopy'
