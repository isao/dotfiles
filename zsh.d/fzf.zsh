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

# CTRL-T - Paste the selected file path(s) into the command line
__fsel() {
    ag -g "" --files-with-matches --all-text | fzf -m | while read item
    do
      [[ -n $item ]] && echo -n "${(q)item} "
    done
}

fzf-file-widget() {
    LBUFFER="${LBUFFER}$(__fsel)"
    zle redisplay
}

zle     -N   fzf-file-widget
bindkey '^T' fzf-file-widget

#
# # ALT-C - cd into the selected directory
# fzf-cd-widget() {
#   local cmd="${FZF_ALT_C_COMMAND:-"command find -L . \\( -path '*/\\.*' -o -fstype 'dev' -o -fstype 'proc' \\) -prune \
#     -o -type d -print 2> /dev/null | sed 1d | cut -b3-"}"
#   cd "${$(eval "$cmd" | $(__fzfcmd) +m):-.}"
#   zle reset-prompt
# }
# zle     -N    fzf-cd-widget
# bindkey '\ec' fzf-cd-widget
#
# # CTRL-R - Paste the selected command from history into the command line
# fzf-history-widget() {
#   local selected num
#   selected=( $(fc -l 1 | fzf +s --tac +m -n2..,.. --tiebreak=index --toggle-sort=ctrl-r -q "${LBUFFER//$/\\$}") )
#   if [ -n "$selected" ]; then
#     num=$selected[1]
#     if [ -n "$num" ]; then
#       zle vi-fetch-history -n $num
#     fi
#   fi
#   zle redisplay
# }
# zle     -N   fzf-history-widget
# bindkey '^R' fzf-history-widget



# # fbr - checkout git branch
fbr() {
  local branches branch
  branches=$(git branch -vv) &&
  branch=$(echo "$branches" | fzf +m) &&
  git checkout $(echo "$branch" | awk '{print $1}' | sed "s/.* //")
}

# # fco - checkout git branch/tag
fco() {
  local tags branches target
  tags=$(
    git tag | awk '{print "\x1b[31;1mtag\x1b[m\t" $1}') || return
  branches=$(
    git branch --all | grep -v HEAD             |
    sed "s/.* //"    | sed "s#remotes/[^/]*/##" |
    sort -u          | awk '{print "\x1b[34;1mbranch\x1b[m\t" $1}') || return
  target=$(
    (echo "$tags"; echo "$branches") |
    fzf-tmux -l30 -- --no-hscroll --ansi +m -d "\t" -n 2) || return
  git checkout $(echo "$target" | awk '{print $2}')
}


# # CTRL-R - Paste the selected command from history into the command line
fzf-history-widget() {
  local selected num
  selected=( $(fc -l 1 | $(__fzfcmd) +s --tac +m -n2..,.. --tiebreak=index --toggle-sort=ctrl-r -q "${LBUFFER//$/\\$}") )
  if [ -n "$selected" ]; then
    num=$selected[1]
    if [ -n "$num" ]; then
      zle vi-fetch-history -n $num
    fi
  fi
  zle redisplay
}

zle     -N   fzf-history-widget
bindkey '^R' fzf-history-widget
