type fzf rg >/dev/null || return
compdef _gnu_generic fzf

# fzf configuration
# ctrl-c copy the selected item
# ctrl-b open the selected item in BBEdit
# ctrl-o open the selected item
#
export FZF_DEFAULT_COMMAND='rg --files'
export FZF_DEFAULT_OPTS='--color=light --tabstop=4 --cycle --exact --multi --reverse --bind="ctrl-c:execute(echo -n {+1} | pbcopy)+abort,ctrl-o:execute(open {+1})+abort,ctrl-b:execute(bbedit {+1})+abort"'

# CTRL-F
# Select file(s).
#
fzf-file-widget() {
    LBUFFER+="$(rg --files | fzf --preview 'echo {}; head -$LINES {}' | xargs)"
    zle redisplay
}
zle -N fzf-file-widget
bindkey '^F' fzf-file-widget

# CTRL-F CTRL-R
# Select a recent file or path via Spotlight/mdfind.
#
fzf-recentfile-widget() {
    LBUFFER+="$(mdfind -onlyin ~/work -onlyin ~/Desktop -onlyin ~/Dropbox -onlyin ~/repos 'date:this month' | fzf -m | xargs)"
    zle redisplay
}
zle -N fzf-recentfile-widget
bindkey '^F^R' fzf-recentfile-widget
# fzf recent items
# alias fzf-recent='mdfind -onlyin ~/work -onlyin ~/Desktop -onlyin ~/Dropbox -onlyin ~/repos "date:this month" | fzf'

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


# ESC GG
# Select git modified file(s).
#
fzf-gitmodified-widget() {
    LBUFFER+="$(git status --short | fzf --exit-0 --preview 'git diff --color {2}'| awk '{print $2}' | xargs)"
    zle redisplay
}
zle -N fzf-gitmodified-widget
bindkey '\egg' fzf-gitmodified-widget

__fzf_gitbranches() {
    git for-each-ref --format='%(refname:short)' $1
}

__fzf_preview_gitshow() {
    fzf --multi --preview='echo "branch: {}"; git show --color --decorate --format=fuller --stat --patch {}' $@
}

# ESC GB
# Select a local git branch.
#
fzf-gitbranches-widget() {
    LBUFFER+="$(__fzf_gitbranches refs/heads/ | __fzf_preview_gitshow -q '!old/ ' )"
    zle redisplay
}
zle -N fzf-gitbranches-widget
bindkey '\egb' fzf-gitbranches-widget

# ESC GBB
# Select any git branch.
#
fzf-gitallbranches-widget() {
    LBUFFER+="$(__fzf_gitbranches | __fzf_preview_gitshow -q '!origin/Dev/releases/ !/submit/request- !old/ ')"
    zle redisplay
}
zle -N fzf-gitallbranches-widget
bindkey '\egbb' fzf-gitallbranches-widget

# ESC GSS
# Select a git stash
fzf-gitstash-widget() {
    LBUFFER+="$(git stash list | cut -d : -f 1 | fzf --preview 'git stash show --color -p {}' --preview-window='right:80%')"
    zle redisplay
}
zle -N fzf-gitstash-widget
bindkey '\egss' fzf-gitstash-widget

