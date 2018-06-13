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

recent-dirs() {
    {   
        [[ -r  ~/.zdirs ]] && cat  ~/.zdirs
        mdfind tag:wip AND kind:folders
    } | awk '!x[$0]++'
    # ^ Dedupe without changing the order (to respect recency) -> awk '!x[$0]++'
    # https://stackoverflow.com/a/11532197/8947435
    # $0 holds the entire contents of a line and square brackets are array
    # access. So, for each line of the file, the node of the array x is
    # incremented and the line printed if the content of that node was not (!)
    # previously set.
}

# Select a directory from dirstack ( ~/.zdirs) or things tagged "wip" w/spotlight.
# See /usr/local/Cellar/fzf/0.17.3/shell/key-bindings.zsh, which does `cd`.
fzf-dirs-widget() {
    LBUFFER+="$(recent-dirs | fzf --no-multi)"
    zle redisplay
}
zle     -N    fzf-dirs-widget
bindkey '\er' fzf-dirs-widget

# Select a recent file or path via Spotlight/mdfind.
fzf-recent-files-widget() {
    LBUFFER+="$(mdfind -onlyin ~/work -onlyin ~/Desktop -onlyin ~/Dropbox -onlyin ~/repos 'kMDItemFSContentChangeDate >= $time.today(-9)' | fzf -m -q '!/dev/Web/ !/repos/skinned/' | xargs)"
    zle redisplay
}
zle -N fzf-recent-files-widget
bindkey '\err' fzf-recent-files-widget # Pick a recent file.

# From /usr/local/opt/fzf/shell/key-bindings.zsh replace "$(__fzfcmd)" with "fzf"
# CTRL-R - Paste the selected command from history into the command line
# Overrides default "^R" history-incremental-search-backward
fzf-history-widget() {
  local selected num
  setopt localoptions noglobsubst noposixbuiltins pipefail 2> /dev/null
  selected=( $(fc -rl 1 |
    FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS -n2..,.. --tiebreak=index --bind=ctrl-r:toggle-sort --query=${(qqq)LBUFFER} +m" fzf) )
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
zle -N fzf-history-widget
bindkey '^r' fzf-history-widget # Replay a history entry.


#
#   FZF GIT WIDGETS
#

# Select git modified file(s).
fzf-git-modified-widget() {
    LBUFFER+="$(git status --short | fzf --exit-0 --preview 'git diff --color {2}'| awk '{print $2}' | xargs)"
    zle redisplay
}
zle -N fzf-git-modified-widget
bindkey '^g^g' fzf-git-modified-widget # Pick changed file in git.

__git-branches() {
    git for-each-ref --format='%(refname:short)' $1
}

__fzf_preview_gitshow() {
    fzf --multi --preview='echo "branch: {}"; git show --color --decorate --format=fuller --stat --patch {}' $@
}

# Select a local git branch.
fzf-gitbranches-widget() {
    LBUFFER+="$(__git-branches refs/heads/ | __fzf_preview_gitshow -q '!old/ ' )"
    zle redisplay
}
zle -N fzf-gitbranches-widget
bindkey '^g^b' fzf-gitbranches-widget # Pick a git local branch.

# Select any git branch.
fzf-git-branches-all-widget() {
    LBUFFER+="$(__git-branches | __fzf_preview_gitshow -q '!origin/Dev/releases/ !/submit/request- !old/ ')"
    zle redisplay
}
zle -N fzf-git-branches-all-widget
bindkey '^g^b^b' fzf-git-branches-all-widget # Pick any git branch.


# Select a git stash
fzf-git-stash-widget() {
    LBUFFER+="$(git stash list | cut -d : -f 1 | fzf --preview 'git stash show --color -p {}' --preview-window='right:80%')"
    zle redisplay
}
zle -N fzf-git-stash-widget
bindkey '^g^t' fzf-git-stash-widget # Pick a git stash.
