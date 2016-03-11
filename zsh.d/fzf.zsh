if ! type fzf >/dev/null
then
    exit 0
fi

#   mine from tcsh.d/fzf.tcsh

# from within fzf:
# ctrl-c copy the selected item
# ctrl-o open the selected item
# ctrl-l open the selected item in less
export FZF_DEFAULT_OPTS='-0 --bind "ctrl-c:execute(echo {}|pbcopy),ctrl-o:execute(open {}),ctrl-l:execute(less {})" --color=light --expect=ctrl-c,ctrl-o,ctrl-l --extended-exact --no-sort --reverse'

if type ag >/dev/null
then
    export FZF_DEFAULT_COMMAND='ag -g "" --files-with-matches'
fi

# fzf recent items
alias fzf-recent='mdfind -onlyin ~/work -onlyin ~/Desktop -onlyin ~/Dropbox -onlyin ~/repos "date:this month" | fzf'

# ctrl-f invoke fzf from the shell line editor
# zle     -N   fzf-file-widget
# bindkey '^f' fzf-file-widget



# source "/usr/local/opt/fzf/shell/key-bindings.zsh"

#
# CTRL-T - Paste the selected file path(s) into the command line
__fzf_files() {
    ag -g "" --files-with-matches --all-text | fzf -m | while read f
    do
      [[ -n $f ]] && echo -n "${(q)f} "
    done
}

fzf-file-widget() {
    LBUFFER="${LBUFFER}$(__fzf_files)"
    zle redisplay
}
zle     -N   fzf-file-widget
bindkey '^T' fzf-file-widget

#
# CTRL-G CTRL-B  select from my git branches
__fzf_gitbranches() {
    git for-each-ref --format='%(refname:short)' $1 | grep -v old/ | fzf
}

fzf-branches-widget() {
    LBUFFER="${LBUFFER}$(echo $(__fzf_gitbranches refs/heads/))"
    zle redisplay
}
zle     -N   fzf-branches-widget
bindkey '^G^B' fzf-branches-widget

#
# CTRL-G CTRL-A  select from all git branches
fzf-allbranches-widget() {
    LBUFFER="${LBUFFER}$(echo $(__fzf_gitbranches))"
    zle redisplay
}
zle     -N   fzf-allbranches-widget
bindkey '^G^A' fzf-allbranches-widget


#
# CTRL-R - Paste the selected command from history into the command line
fzf-history-widget() {
    local selected num
    selected=( $(fc -l 1 | fzf +s --tac +m -n2..,.. --tiebreak=index --toggle-sort=ctrl-r -q "${LBUFFER//$/\\$}") )
    if [ -n "$selected" ]
    then
        num=$selected[1]

        if [ -n "$num" ]
        then
            zle vi-fetch-history -n $num
        fi
  fi
  zle redisplay
}

zle     -N   fzf-history-widget
bindkey '^R' fzf-history-widget
