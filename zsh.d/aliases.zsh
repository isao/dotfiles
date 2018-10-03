#
# built-ins
#

alias cd..='cd ..'
alias ls='ls -FG'
alias l=ls
alias ll='/bin/ls -lG'
alias kk=ll
alias lll=ll
alias ls.='ls -dG .?*'  # ls dot files & dirs only
alias ll.='ls -dGl .?*' # ls dot files & dirs only
alias la='ll -A'
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
alias showkeys='rg --no-line-number -o "^\s*bindkey .+$" $dotfiles/zsh*'
alias checkpath='ls -ld $(echo $PATH | tr : "\n")'


# git
alias gg='git status --branch --short'
alias ggg='gg --ignored'
alias gggg='git status --short --ignored | cut -c 4- | cut -d / -f 1-2 | sort | uniq -c'
alias gb='git branch --color -v | egrep -v "^. old/" | cut -c 1-$(tput cols)'
alias gd='git diff'
alias gdt='git difftool'
alias gf='git fetch -p'
alias gp='git pull -p --ff-only'
alias gu='git gui browser'
alias gr='git remote -v'
alias gsa='git stash apply'
alias gsd='git stash drop'
alias gsl='git stash list'
alias gsv='git stash save'
alias gss='git stash show'

alias npr='npm run'

# tig
alias tgs='tig status'
alias tgl='tig log'
alias tgb='tig blame -w -C'

# ripgrep
alias rgg='rg --glob "*.{html,less,css,js,ts,tsx,md,txt,json5?}" --glob "!{node_modules,dist}"'

# osx

#remove style from any text on the clipboard
alias plaintext='pbpaste -Prefer txt | pbcopy'
