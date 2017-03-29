type fzf rg >/dev/null || return
compdef _gnu_generic fzf
compdef _gnu_generic rg


# fzf configuration
#
export FZF_DEFAULT_COMMAND='rg --files'
export FZF_DEFAULT_OPTS='--bind="ctrl-o:execute(open {}),ctrl-l:execute(less {})" --expect=ctrl-o,ctrl-l --color=light --exact --no-sort --reverse'

# bind is broken!!!!!
# from within fzf:
# ctrl-c copy the selected item
# ctrl-o open the selected item
# ctrl-l open the selected item in less


# CTRL-F
# Select a file.
#
fzf-file-widget() {
    LBUFFER+="$(rg --files | fzf -m | sed 1d)"
    zle redisplay
}
zle -N fzf-file-widget
bindkey '^F' fzf-file-widget

# CTRL-F CTRL-G
# Select a modified file.
#
fzf-gitmodified-widget() {
    LBUFFER+="$(git status --short | fzf -m | awk '{if (NR!=1) {print $2}}')"
    zle redisplay
}
zle -N fzf-gitmodified-widget
bindkey '^F^G' fzf-gitmodified-widget

# CTRL-F CTRL-R
# Select a recent file or path via Spotlight/mdfind.
#
fzf-recentfile-widget() {
    LBUFFER+="$(mdfind -onlyin ~/work -onlyin ~/Desktop -onlyin ~/Dropbox -onlyin ~/repos 'date:this month' | fzf -m | sed 1d)"
    zle redisplay
}
zle -N fzf-recentfile-widget
bindkey '^F^R' fzf-recentfile-widget

# fzf recent items
# alias fzf-recent='mdfind -onlyin ~/work -onlyin ~/Desktop -onlyin ~/Dropbox -onlyin ~/repos "date:this month" | fzf'

__fzf_gitbranches() {
    git for-each-ref --format='%(refname:short)' $1
}

# CTRL-B CTRL-B
# Select a local git branch.
#
fzf-gitbranches-widget() {
    LBUFFER+="$(__fzf_gitbranches refs/heads/ | fzf -q '!old/ ' --multi --preview 'git show {}' | sed 1d)"
    #LBUFFER+="$(git branch -v | fzf -q '!old/ ' | awk '{if (NR!=1) {print $1}}')"
    zle redisplay
}
zle -N fzf-gitbranches-widget
bindkey '^B^B' fzf-gitbranches-widget

# CTRL-B CTRL-B CTRL-B
# Select any git branch.
#
fzf-gitallbranches-widget() {
    LBUFFER+="$(__fzf_gitbranches | fzf -q '!origin/Dev/releases/ !/submit/request- !old/ ' --multi --preview 'git show {}' | sed 1d)"
    #LBUFFER+="$(git branch -rv | fzf -q '!origin/Dev/releases/ !/submit/request- ' | awk '{if (NR!=1) {print $1}}')"
    zle redisplay
}
zle -N fzf-gitallbranches-widget
bindkey '^B^B^B' fzf-gitallbranches-widget

# CTRL-R
# Navigate history.
#
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
zle -N fzf-history-widget
bindkey '^R' fzf-history-widget
