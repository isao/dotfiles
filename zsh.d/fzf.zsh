type fzf rg >/dev/null || return
type fzf >/dev/null && compdef _gnu_generic fzf
type rg >/dev/null && compdef _gnu_generic rg


# fzf configuration
#
export FZF_DEFAULT_OPTS='-0 --bind "ctrl-c:execute(echo {}|pbcopy),ctrl-o:execute(open {}),ctrl-l:execute(less {})" --color=light --expect=ctrl-c,ctrl-o,ctrl-l --extended-exact --no-sort --reverse'
# from within fzf:
# ctrl-c copy the selected item
# ctrl-o open the selected item
# ctrl-l open the selected item in less
export FZF_DEFAULT_COMMAND='rg "" --files-with-matches'


# CTRL-F
# Select a file.
#
fzf-file-widget() {
    LBUFFER="${LBUFFER}$(echo $(rg "" --files-with-matches | fzf -m | sed 1d))"
    zle redisplay
}
zle -N fzf-file-widget
bindkey '^F' fzf-file-widget

# CTRL-F CTRL-R
# Select a recent file or path via Spotlight/mdfind.
#
fzf-recentfile-widget() {
	filelist=$(mdfind -onlyin ~/work -onlyin ~/Desktop -onlyin ~/Dropbox -onlyin ~/repos 'date:this month' | fzf -m | sed 1d)
    LBUFFER="${LBUFFER}$(echo $filelist)"
    zle redisplay
}
zle -N fzf-recentfile-widget
bindkey '^F^R' fzf-recentfile-widget

# fzf recent items
# alias fzf-recent='mdfind -onlyin ~/work -onlyin ~/Desktop -onlyin ~/Dropbox -onlyin ~/repos "date:this month" | fzf'

__fzf_gitbranches() {
    git for-each-ref --format='%(refname:short)' $1 | grep -v old/ | fzf | sed 1d
}

# CTRL-B CTRL-B
# Select a local git branch.
#
fzf-gitbranches-widget() {
    LBUFFER="${LBUFFER}$(echo $(__fzf_gitbranches refs/heads/))"
    zle redisplay
}
zle -N fzf-gitbranches-widget
bindkey '^B^B' fzf-gitbranches-widget

# CTRL-B CTRL-B CTRL-B
# Select any git branch.
#
fzf-gitallbranches-widget() {
    LBUFFER="${LBUFFER}$(echo $(__fzf_gitbranches))"
    zle redisplay
}
zle -N fzf-gitallbranches-widget
bindkey '^B^B^B' fzf-gitallbranches-widget

gco() {
    branch="$(__fzf_gitbranches refs/heads/)"
    [[ -n $branch ]] && git checkout $branch
}

# CTRL-G CTRL-G
# Select a modified file.
#
fzf-gitmodified-widget() {
    LBUFFER="${LBUFFER}$(echo $(git status --short | awk '{ print $2 }' | fzf -m | sed 1d))"
    zle redisplay
}
zle -N fzf-gitmodified-widget
bindkey '^G^G' fzf-gitmodified-widget

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
