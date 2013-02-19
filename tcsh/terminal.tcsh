# keys
bindkey "^[[5C" forward-word
bindkey "^[[C"  forward-word
bindkey "^[[5D" backward-word
bindkey "^[[D"  backward-word
bindkey "^I"    complete-word-fwd
bindkey -k down history-search-forward
bindkey -k up   history-search-backward
bindkey "^w"    delete-word
bindkey "^[[3~" delete-char

# completions, corrections
# correct options are all | cmd | complete
set implicitcd
set correct = cmd
set complete = enhance
set autolist

# color?
set color
set colorcat

# ~/.history contains line: history -S
# histdup 'prev' no immediate dupes; 'all' no dupes in history
set history = 3000
set savehist = (3000 merge)
set histdup = 'prev'
#set histfile = ~/.history-$HOST

# ls
set listflags = 'hx'
set listlinks
#unset addsuffix

# watch for local logins
set watch = ( 1 any any )
set who = '%B%n%b %a %l from host %B%M%b at %t'

# don't logout
set autologout = 0

# feedback
set notify
set noding
set ellipsis

# cmd to get git branch name, or "svn", or nothing
#set _promptvcs = 'sh -c "test -d .svn && echo svn || git name-rev --name-only HEAD 2>/dev/null"'
set _promptvcs = 'test -d .svn && echo svn || git branch |& grep ^\* | cut -c3-33'

# see ./y.tcsh
if($?YROOT_NAME) then
  set _promptroot = "%B$YROOT_NAME%b"
else
  set _promptroot = ''
endif

# set window title to host:path; set prompt to time+user+$VCS
sched +0:00 alias precmd 'set prompt="%{\033]0;%n@%m:%c03\007%}%T%n$_promptroot%{\033[34m%}`$_promptvcs`%{\033[0m%}%# "'

# display currently running command(s) in window title
sched +0:00 alias postcmd 'printf "\033]0;%s %s\007" `hostname -s` "\!#"'

# %{string%}  includes string as a literal escape sequence
# %n          user name
# %m          short hostname
# %c3         last 3 dirs of cwd w/ ~ substitution
# %~          cwd w/ ~ substition
# %T          24-hour time
# %#          promptchars shell var; '#', '>', or '%', etc.
# %L          clear to eol or eop
# !#          history substution of current event
#set prompt = '%{\033]0;%n@%m:%c03\007%}%T%n%# %L'
#set prompt = '%T%n@%m:%c2%# '

# http://www.nparikh.org/unix/prompt.php
# %{\033[31m%} color start 31 is color code
# %{\033[0m%}  color end
# 30 - black
# 31 - red
# 32 - green
# 33 - yellow
# 34 - blue
# 35 - magenta
# 36 - cyan
# 37 - white
