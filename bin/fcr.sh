#!/bin/bash -eu
# fbr - checkout git branch (including remote branches)
# https://github.com/junegunn/fzf/wiki/examples

branches=$(git branch --all | grep -v HEAD) &&
branch=$(echo "$branches" |
       fzf-tmux -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
