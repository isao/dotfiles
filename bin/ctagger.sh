#!/bin/bash -eo pipefail

# Helper script to run `ctags` [Universal ctags](https://github.com/universal-ctags/ctags)
# - run from the git repo base dir.
# - works from BBEdit script menu.
# - reads options from `.ctagger` config files in that directory (default `-R`).
#   - can specify sub-directories, globs etc.
#       for example: `-R app tests/*helper* *.md *.js package.json`
# - run in the background and raise a notification when done

function err() {
    echo $2 >&2
    exit $1
}

function alert() {
    osascript -e "display notification \"$basedir indexed.\" with title \"$scriptname\""
}

#
#   Are ctags configured?
#
type ctags >/dev/null \
    || err 1 "Error: you need to install ctags (brew install --HEAD universal-ctags/universal-ctags/universal-ctags)."

[[ -d ~/.ctags.d ]] || err 3 "Error: you need to configure ~/.ctags.d"

#
#   Environment.
#
scriptname=$(basename "$0" .sh)

# If invoked from BBEdit Script Menu...
[[ -f $BB_DOC_PATH ]] && cd "$(dirname "$BB_DOC_PATH")"

basedir="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$basedir"

#
#   Load arguments to ctags from a file, one per line, ignoring lines with "#".
#
conf=$(test -r .ctagger && grep -v \# .ctagger | xargs || echo '-R')

#
#   Invoke ctags in the background, raise notification when done.
#
ctags $@ $conf && alert

type ctags-index-hbs.zsh >/dev/null && ctags-index-hbs.zsh
