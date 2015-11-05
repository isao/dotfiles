if(-X fzf) then
    setenv FZF_DEFAULT_OPTS '-0 --bind "ctrl-c:execute(echo {}|pbcopy),ctrl-o:execute(open {}),ctrl-l:execute(less {})" --color=light --expect=ctrl-c,ctrl-o,ctrl-l --extended-exact --multi --no-sort'
    if(-X ag) then
        setenv FZF_DEFAULT_COMMAND 'ag -g "" --files-with-matches'
    endif
endif

# find recent
alias fzfr 'mdfind -onlyin ~/work -onlyin ~/Dropbox -onlyin ~/repos "date:this month" | fzf'
#bindkey -c '^r' fzfr