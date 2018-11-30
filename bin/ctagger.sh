#!/bin/bash -eo pipefail

function err() {
    echo $2 >&2
    exit $1
}

function alert() {
    osascript -e "display notification \"$basedir\" with title \"$scriptname\""
}

#
#   Are ctags configured?
#
type ctags >/dev/null || err 1 "Error: you need to install ctags (brew install --HEAD universal-ctags/universal-ctags/universal-ctags)."
[[ -d ~/.ctags.d ]] || err 3 "Error: you need to configure ~/.ctags.d"

#
#   Environment.
#
scriptname=$(basename "$0" .sh)
# If invoked from BBEdit Script Menu...
[[ -n $BB_DOC_PATH ]] && cd "$(dirname "$BB_DOC_PATH")"
basedir="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$basedir"

#
#   Load arguments to ctags from a file, one per line, ignoring lines with "#".
#
conf=$(test -r .ctagger && grep -v \# .ctagger | xargs)

#
#   Invoke ctags in the background, raise notification when done.
#
ctags $@ $conf && alert
