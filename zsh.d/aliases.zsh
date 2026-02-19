#
#   built-ins
#

alias cd..='cd ..'  # typo
alias ls='ls -FGH'  # -F display symbol after pathnames; -G colorize; -H follow symlink
alias l='ls'
alias ll='/bin/ls -lhGH'
alias kk=ll  # typo
alias lll=ll  # typo
alias ls.='ls -dG .?*'  # ls dot files & dirs only
alias ll.='ls -dGl .?*' # ll dot files & dirs only
alias la='ll -A'
alias lsd='/bin/ls -d */'   # ls just directories
alias lld='/bin/ls -dl */'  # ll just directories

#
#   one-liners
#

alias grep='grep --color=auto'
alias nocolors="perl -pe 's/\e\[?.*?[\@-~]//g'"
alias rot13='perl -wne "tr/a-zA-Z/n-za-mN-ZA-M/;print;"'
alias showenv='env | sort'
alias showpath="print -l $path"
alias showkeys='rg --no-line-number -o "^bindkey .+$" $myzshd/*.zsh'
alias checkpath='ls -ld $(echo $PATH | tr : "\n")'

alias e="$(where bbedit zed code nano vim vi | grep ^/ | head -1)"

# Without `setopt share_history`, history is not shared between sessions, until
# you do this:
alias sync-history='fc -R'

#
#   osx
#

# remove style from any text on the clipboard
alias plaintext='pbpaste -Prefer txt | pbcopy'

# https://furbo.org/2021/08/25/jsc-my-new-best-friend/
alias jsc='/System/Library/Frameworks/JavaScriptCore.framework/Versions/Current/Helpers/jsc'

# Enable hyperlinks
alias fd='fd --hyperlink=auto'
