#!/bin/sh -euo pipefail

qry=${1:-}
out=$(fzf --query="$qry" --exit-0 --expect=ctrl-o,ctrl-l)
key=$(head -1 <<< "$out")
file=$(head -2 <<< "$out" | tail -1)

if [ -n "$file" ]
then
    [ "$key" = ctrl-o ] && open "$file"
    [ "$key" = ctrl-l ] && less "$file"
fi
