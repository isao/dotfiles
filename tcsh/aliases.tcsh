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

#osx
if($?OSTYPE && $OSTYPE == 'darwin') then
  #remove style from any text on the clipboard
  alias plaintext 'pbpaste -Prefer txt | pbcopy'

  # http://episteme.arstechnica.com/eve/forums/a/tpc/f/8300945231/m/284004131041
  # view man page as a PDF
  alias man2pdf 'man -t \!* | open -f -a /Applications/Preview.app'

  #cd to finder cwd
  if(-f ~/Repos/1st/shell/misc-osx/findercwd.applescript) \
      alias fcwd 'cd `osascript ~/Repos/1st/shell/misc-osx/findercwd.applescript`'

  alias gitbox 'open -a Gitbox \!*'

endif

#quick svn statuses
if(-X svn) then
  alias ss  'svn status --quiet --ignore-externals \!*'
  alias ss? 'svn status \!* | grep ^\?'
  alias sss "svn status --no-ignore \!*"
endif

#quick git statuses
if(-X git) then
  alias gu  'git gui \!*'
  if(-X bbdiff) alias gd 'git difftool \!*'
  alias gg  'git status --short \!*'
  alias ggg 'git status --short --ignored --branch \!* && git stash list'
endif
