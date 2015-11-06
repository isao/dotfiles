if(-X fzf) then
    # from within fzf:
    # ctrl-c copy the selected item
    # ctrl-o open the selected item
    # ctrl-l open the selected item in less
    setenv FZF_DEFAULT_OPTS '-0 --bind "ctrl-c:execute(echo {}|pbcopy),ctrl-o:execute(open {}),ctrl-l:execute(less {})" --color=light --expect=ctrl-c,ctrl-o,ctrl-l --extended-exact --no-sort --reverse'

    if(-X ag) then
        setenv FZF_DEFAULT_COMMAND 'ag -g "" --files-with-matches'
    endif

    # ctrl-f invoke fzf from the shell line editor
    bindkey -c '^f' fzf

    # fzf recent items
    alias fzf-recent 'mdfind -onlyin ~/work -onlyin ~/Dropbox -onlyin ~/repos "date:this month" | fzf'
endif

