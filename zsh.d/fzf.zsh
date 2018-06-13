type fzf rg >/dev/null || return

#
#   FZF CONFIG
#

# FZF Completion functions
#[[ $- == *i* ]] && source "/usr/local/opt/fzf/shell/completion.zsh" 2> /dev/null

# fzf configuration
# ctrl-c copy the selected item
# ctrl-e edit the selected item
# ctrl-o open the selected item
# ctrl-r reveal the selected item in the Finder
#
export FZF_DEFAULT_COMMAND='rg --files'
export FZF_DEFAULT_OPTS='--color=light --tabstop=4 --cycle --exact --multi --reverse --bind="ctrl-c:execute(echo -n {} | pbcopy)+abort,ctrl-o:execute(open {+1})+abort,ctrl-r:execute(open -R {+1})+abort,ctrl-e:execute($EDITOR {})+abort"'

#
#   FZF WIDGETS
#
#   Tip: Show all the custom `bindkey` assignments with alias `showkeys`.

# Select file(s).
fzf-file-widget() {
    LBUFFER+="$(rg --files | fzf --preview 'echo {}; head -$LINES {} | highlight {} --out-format xterm256 --quiet --force --style fine_blue' | xargs)"
    zle redisplay
}
zle -N fzf-file-widget
bindkey '^f^f' fzf-file-widget              # Find file.

# Save and restore dirstack.
DIRSTACKFILE=~/.zdirs
DIRSTACKSIZE=66
if [[ -f $DIRSTACKFILE ]] && [[ $#dirstack -eq 0 ]]
then
    dirstack=(${(f)"$(< $DIRSTACKFILE)"})
fi
chpwd() {
    print -l $PWD ${(u)dirstack} >$DIRSTACKFILE
}

# Ensure precmds are run after cd
# See /usr/local/Cellar/fzf/0.17.3/shell/key-bindings.zsh
fzf-redraw-prompt() {
  local precmd
  for precmd in $precmd_functions; do
    $precmd
  done
  zle reset-prompt
}
zle -N fzf-redraw-prompt


# Select recent dirs, and ones tagged "wip".
fzf-dirs-widget() {
    local dir="$({cat ~/.zdirs; mdfind tag:wip AND kind:folders} | awk '!x[$0]++' | fzf --no-multi)"
    # ^ Dedupe without changing the order (to respect recency) -> awk '!x[$0]++'
    # https://stackoverflow.com/a/11532197/8947435
    # $0 holds the entire contents of a line and square brackets are array
    # access. So, for each line of the file, the node of the array x is
    # incremented and the line printed if the content of that node was not (!)
    # previously set.

    # See /usr/local/Cellar/fzf/0.17.3/shell/key-bindings.zsh
    if [[ -z "$dir" ]]; then
      zle redisplay
      return 0
    fi

    cd "$dir"
    local ret=$?
    zle fzf-redraw-prompt
    typeset -f zle-line-init >/dev/null && zle zle-line-init
    return $ret
}
zle     -N    fzf-dirs-widget
bindkey '^f^d' fzf-dirs-widget               # Change to a recent (or "wip" tagged) directory.

# Select a recent file or path via Spotlight/mdfind.
fzf-recentfile-widget() {
    LBUFFER+="$(mdfind -onlyin ~/work -onlyin ~/Desktop -onlyin ~/Dropbox -onlyin ~/repos 'kMDItemFSContentChangeDate >= $time.today(-9)' | fzf -m | xargs)"
    zle redisplay
}
zle -N fzf-recentfile-widget
bindkey '^f^r' fzf-recentfile-widget        # Pick a recent file.

# From /usr/local/opt/fzf/shell/key-bindings.zsh replace "$(__fzfcmd)" with "fzf"
# CTRL-R - Paste the selected command from history into the command line
# Overrides default "^R" history-incremental-search-backward
fzf-history-widget() {
  local selected num
  setopt localoptions noglobsubst noposixbuiltins pipefail 2> /dev/null
  selected=( $(fc -rl 1 |
    FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS -n2..,.. --tiebreak=index --bind=ctrl-r:toggle-sort $FZF_CTRL_R_OPTS --query=${(qqq)LBUFFER} +m" fzf) )
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
bindkey '^r' fzf-history-widget             # CTRL-R: Replay a history entry.


#
#   FZF GIT WIDGETS
#

# Select git modified file(s).
fzf-gitmodified-widget() {
    LBUFFER+="$(git status --short | fzf --exit-0 --preview 'git diff --color {2}'| awk '{print $2}' | xargs)"
    zle redisplay
}
zle -N fzf-gitmodified-widget
bindkey '^g^g' fzf-gitmodified-widget       # ESC GG: Pick a new or modified file from git status.

__fzf_gitbranches() {
    git for-each-ref --format='%(refname:short)' $1
}

__fzf_preview_gitshow() {
    fzf --multi --preview='echo "branch: {}"; git show --color --decorate --format=fuller --stat --patch {}' $@
}

# Select a local git branch.
fzf-gitbranches-widget() {
    LBUFFER+="$(__fzf_gitbranches refs/heads/ | __fzf_preview_gitshow -q '!old/ ' )"
    zle redisplay
}
zle -N fzf-gitbranches-widget
bindkey '^g^b' fzf-gitbranches-widget       # ESC GB: pick a git local branch

# Select any git branch.
fzf-gitallbranches-widget() {
    LBUFFER+="$(__fzf_gitbranches | __fzf_preview_gitshow -q '!origin/Dev/releases/ !/submit/request- !old/ ')"
    zle redisplay
}
zle -N fzf-gitallbranches-widget
bindkey '\^g^b^b' fzf-gitallbranches-widget


# Select a git stash
fzf-gitstash-widget() {
    LBUFFER+="$(git stash list | cut -d : -f 1 | fzf --preview 'git stash show --color -p {}' --preview-window='right:80%')"
    zle redisplay
}
zle -N fzf-gitstash-widget
bindkey '^g^s' fzf-gitstash-widget
