#
# built-ins
#
alias . pwd
alias .. 'cd ..'
alias ls 'ls -F'
alias ll '/bin/ls -lF \!*'
alias lsd '/bin/ls -l \!* | grep ^d'  # ls dirs only
alias ls. '/bin/ls -dF .?*'  # ls dot files & dirs only

#freq typos
alias cd.. 'cd ..'
alias l ll


#
# one-liners
#
alias = "python -c 'print \!*'"
alias dict "curl -s 'dict://dict.org/d:\!*' | egrep -v '^[0-9]{3} .*|^\.'"
alias ip "ifconfig | grep 'inet '"
alias man2txt 'man \!* | col -b'
alias rmmacmeta "find \!* \( -name '.DS_Store' -or -name '._*' \) -exec rm -v \{\} \;"
alias rot13 'perl -wne "tr/a-zA-Z/n-za-mN-ZA-M/;print;"'
alias word 'grep \!* /usr/share/dict/words'

alias showenv 'env | sort'
alias showpath 'echo $PATH | tr : "\n"'
alias checkpath 'ls -ld `echo $PATH | tr : "\n"`'

#
# app shortcuts
#
alias e "$EDITOR \!*"

if(-X pbpaste) alias plaintext 'pbpaste -Prefer txt | pbcopy'

if(-X icalBuddy) then
  alias icb "icalBuddy -f -b '' -df '%m %d' -tf '%H:%M' -eed -nc -npn -po datetime,title,location -eep notes,url -ps '|\t| |' eventsToday\!*"
  #icb
endif

# http://episteme.arstechnica.com/eve/forums/a/tpc/f/8300945231/m/284004131041
# view man page as a PDF
if(-x /Applications/Preview.app) alias man2pdf 'man -t \!* | open -f -a /Applications/Preview.app'

if(-X osascript) then
  alias fcd 'cd `osascript ~/Repos/shell/misc-osx/findercwd.applescript`'
endif

if(-X svn) then
  alias s 'svn status --quiet --ignore-externals \!*'
  alias ss 'svn status \!* | grep ^\?'
  alias sss "svn status --no-ignore \!* |egrep '^[?IX]'"
endif

if(-X git) then
  alias g 'git status --short --untracked-files=no \!*'
  alias gg 'git status --short --untracked-files=normal \!* | grep ^\? && git stash list'
  alias ggg 'git status --short \!*'
  alias gu 'git gui \!*'
  if(-X bbdiff) alias gd 'git difftool \!*'
endif
