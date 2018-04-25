type fzf rg >/dev/null || return

# compdef _gnu_generic fzf

# FZF Completion functions
#[[ $- == *i* ]] && source "/usr/local/opt/fzf/shell/completion.zsh" 2> /dev/null

# fzf configuration
# ctrl-c copy the selected item
# ctrl-b open the selected item in BBEdit
# ctrl-o open the selected item
#
export FZF_DEFAULT_COMMAND='rg --files'
export FZF_DEFAULT_OPTS='--color=light --tabstop=4 --cycle --exact --multi --reverse --bind="ctrl-c:execute(echo -n {} | pbcopy)+abort,ctrl-o:execute(open {+1})+abort,ctrl-b:execute(bbedit {})+abort"'

# ESC F F
# Select file(s).
#
fzf-file-widget() {
    LBUFFER+="$(rg --files | fzf --preview 'echo {}; head -$LINES {}' | xargs)"
    zle redisplay
}
zle -N fzf-file-widget
bindkey '\eff' fzf-file-widget

# ESC R
# Select a directory from ~/.zdirs or tag:wip.
DIRSTACKFILE=~/.zdirs
DIRSTACKSIZE=66
if [[ -f $DIRSTACKFILE ]] && [[ $#dirstack -eq 0 ]]
then
    dirstack=(${(f)"$(< $DIRSTACKFILE)"})
fi
chpwd() {
    print -l $PWD ${(u)dirstack} >$DIRSTACKFILE
}
fzf-dirs-widget() {
    LBUFFER+="$({cat ~/.zdirs; mdfind tag:wip AND kind:folders} | awk '!x[$0]++' | fzf --no-multi)"
    # Dedupe without changing the order (to respect recency) -> awk '!x[$0]++'
    # https://stackoverflow.com/a/11532197/8947435
    # $0 holds the entire contents of a line and square brackets are array
    # access. So, for each line of the file, the node of the array x is
    # incremented and the line printed if the content of that node was not (!)
    # previously set.
    zle redisplay
}
zle     -N    fzf-dirs-widget
bindkey '\er' fzf-dirs-widget

# ESC R R
# Select a recent file or path via Spotlight/mdfind.
#
fzf-recentfile-widget() {
    LBUFFER+="$(mdfind -onlyin ~/work -onlyin ~/Desktop -onlyin ~/Dropbox -onlyin ~/repos 'kMDItemFSContentChangeDate >= $time.today(-9)' | fzf -m | xargs)"
    zle redisplay
}
zle -N fzf-recentfile-widget
bindkey '\err' fzf-recentfile-widget

# From /usr/local/opt/fzf/shell/key-bindings.zsh replace "$(__fzfcmd)" with "fzf"
# CTRL-R - Paste the selected command from history into the command line
# Overrides default "^R" history-incremental-search-backward
fzf-history-widget() {
  local selected num
  setopt localoptions noglobsubst noposixbuiltins pipefail 2> /dev/null
  selected=( $(fc -rl 1 |
    FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} $FZF_DEFAULT_OPTS -n2..,.. --tiebreak=index --bind=ctrl-r:toggle-sort $FZF_CTRL_R_OPTS --query=${(qqq)LBUFFER} +m" fzf) )
  local ret=$?
  if [ -n "$selected" ]; then
    num=$selected[1]
    if [ -n "$num" ]; then
      zle vi-fetch-history -n $num
    fi
  fi
  zle redisplay
  typeset -f zle-line-init >/dev/null && zle zle-line-init
  return $ret
}
zle     -N   fzf-history-widget
bindkey '^R' fzf-history-widget


#
#   GIT
#

# ESC G G
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

# ESC G B
# Select a local git branch.
#
fzf-gitbranches-widget() {
    LBUFFER+="$(__fzf_gitbranches refs/heads/ | __fzf_preview_gitshow -q '!old/ ' )"
    zle redisplay
}
zle -N fzf-gitbranches-widget
bindkey '\egb' fzf-gitbranches-widget

# ESC G B B
# Select any git branch.
#
fzf-gitallbranches-widget() {
    LBUFFER+="$(__fzf_gitbranches | __fzf_preview_gitshow -q '!origin/Dev/releases/ !/submit/request- !old/ ')"
    zle redisplay
}
zle -N fzf-gitallbranches-widget
bindkey '\egbb' fzf-gitallbranches-widget

# ESC G S S
# Select a git stash
fzf-gitstash-widget() {
    LBUFFER+="$(git stash list | cut -d : -f 1 | fzf --preview 'git stash show --color -p {}' --preview-window='right:80%')"
    zle redisplay
}
zle -N fzf-gitstash-widget
bindkey '\egss' fzf-gitstash-widget
