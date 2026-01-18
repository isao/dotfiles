whence fzf fd >/dev/null || return

#
#   FZF CONFIG
#

# Note: not using the functions that ship with fzf
# https://github.com/junegunn/fzf#key-bindings-for-command-line
#   source "$HOMEBREW_PREFIX/Cellar/fzf/0.21.0-1/shell/key-bindings.zsh"
# https://github.com/junegunn/fzf#fuzzy-completion-for-bash-and-zsh
#   source "$HOMEBREW_PREFIX/Cellar/fzf/0.21.0-1/shell/completion.zsh"

# fzf configuration
# ctrl-c copy the selected item
# ctrl-e edit the selected item with $EDITOR
# ctrl-o open the selected item
# ctrl-r reveal the selected item in the Finder
#
export FZF_DEFAULT_COMMAND=fd
export FZF_DEFAULT_OPTS='--color=light --tabstop=4 --cycle --exact --multi --reverse --bind="ctrl-c:execute(echo -n {-1} | pbcopy)+abort" --bind="ctrl-o:execute(open {-1})+abort" --bind="ctrl-r:execute(open -R {-1})+abort" --bind="ctrl-e:execute($EDITOR {-1})+abort"'


#
# Set up official fzf key bindings and fuzzy completion
# eval "$(fzf --zsh)"
#

#
#   My FZF functions
#

# Find in file
# Based on: https://github.com/junegunn/fzf/wiki/Examples#searching-file-contents
fif() {
    local rgflags preview
    if [[ -z $1 ]]
    then
        echo "Missing search string"
        return 1
    fi
    rgflags='--colors "match:bg:green" --ignore-case --pretty --context 5'
    preview="bat --color=always | rg $rgflags '$1' || rg $rgflags '$1' {}"
    rg --files-with-matches --no-messages "$1" . | fzf --preview $preview
}

#
#   FZF WIDGETS
#
#   Tip: Show all the custom `bindkey` assignments with alias `showkeys`.

# Helper: Extract word under cursor from LBUFFER/RBUFFER.
# Sets: _fzf_query, _fzf_prefix, _fzf_suffix
#
# Examples (| = cursor):
#   command line         LBUFFER            RBUFFER        _fzf_query
#   ──────────────────   ────────────────   ────────────   ─────────────
#   "cd proj|"           "cd proj"          ""             "proj"
#   "cd foo/bar/baz|"    "cd foo/bar/baz"   ""             "foo/bar/baz"
#   "cmd --foo=bar|"     "cmd --foo=bar"    ""             "bar"
#   "cd proj|ects"       "cd proj"          "ects"         "projects"
#   "vim |main.ts"       "vim "             "main.ts"      "main.ts"
#
_fzf_word_under_cursor() {
    local left="${LBUFFER##*[ =]}"   # partial word before cursor (after last space or =)
    local right="${RBUFFER%% *}"     # partial word after cursor (up to first space)
    _fzf_query="${left}${right}"     # complete word at/under cursor
    _fzf_prefix="${LBUFFER%$left}"   # everything before the word
    _fzf_suffix="${RBUFFER#$right}"  # everything after the word
}

# Helper: Replace word under cursor with selection (requires _fzf_word_under_cursor first).
_fzf_replace_word() {
    if [[ -n "$1" ]]; then
        LBUFFER="${_fzf_prefix}$1"
        RBUFFER="${_fzf_suffix}"
    fi
}

fzf-filenames-widget() {
    _fzf_word_under_cursor
    local selected="$(command fd -t f | fzf --query="$_fzf_query" --style full --preview 'fzf-preview.sh {}' --bind 'focus:transform-header:file --brief {}' | xargs)"
    _fzf_replace_word "$selected"
    zle redisplay
}
zle -N fzf-filenames-widget
bindkey '^f^f' fzf-filenames-widget # Find file.

fzf-dirnames-widget() {
    _fzf_word_under_cursor
    local selected="$(fd -t d | fzf --query="$_fzf_query" --preview 'echo {}; ls -1 {}' --preview-window '~1' | xargs)"
    _fzf_replace_word "$selected"
    zle redisplay
}
zle -N fzf-dirnames-widget
bindkey '^f^d' fzf-dirnames-widget # Find dir.

recent-dirs() {
    {
        [[ -r "$DIRSTACKFILE" ]] && cat "$DIRSTACKFILE"
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
# See $HOMEBREW_PREFIX/Cellar/fzf/0.17.3/shell/key-bindings.zsh, which does `cd`.
fzf-recent-dirs-widget() {
    LBUFFER+="$(recent-dirs | fzf --no-multi)"
    zle redisplay
}
zle     -N    fzf-recent-dirs-widget
bindkey '\er' fzf-recent-dirs-widget # Pick a recent directory.

# Select a recent file or path via Spotlight/mdfind.
fzf-recent-files-widget() {
    LBUFFER+="$(mdfind -onlyin ~/Documents -onlyin ~/Desktop -onlyin ~/notes -onlyin ~/work 'kMDItemFSContentChangeDate >= $time.today(-14)' | fzf -m | xargs)"
    zle redisplay
}
zle -N fzf-recent-files-widget
bindkey '\erf' fzf-recent-files-widget # Pick a recent file.

# From $HOMEBREW_PREFIX/opt/fzf/shell/key-bindings.zsh replace "$(__fzfcmd)" with "fzf"
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
