if(-X fzf) then
    setenv FZF_DEFAULT_OPTS '-0 --bind "ctrl-o:execute(open {}),ctrl-l:execute(less {})" --color=light --expect=ctrl-o,ctrl-l --extended-exact --multi'
    if(-X ag) then
        setenv FZF_DEFAULT_COMMAND 'ag -g "" --files-with-matches'
    endif
endif
