#!/bin/bash -eo pipefail

#   FUNCTIONS
#
err()
{
    echo $2 >&2
    exit $1
}

maketags()
{
    cd "$basedir"
    ctags $excludes $args $paths
}

alert()
{
    osascript -e "display notification \"$basedir\" with title \"$scriptname\""
}

#   CHECKS
#
type ctags >/dev/null || err 1 "Error: you need to install ctags (brew install universal-ctags)."
[[ -d ~/.ctags.d ]] || err 3 "Error: you need to install ~/.ctags https://git.io/vDE8C"

#   PARAMS
#

scriptname=$(basename "$0" .sh)
args=$*
excludes=
paths=
basedir=

# If invoked from BBEdit Script Menu...
[[ -n $BB_DOC_PATH ]] && cd "$(dirname "$BB_DOC_PATH")"

# If invoked via .git/hooks...
[[ -n $GIT_DIR ]] && args=

# If we're in the ReachClient repo...
if [[ $(git remote -v 2>/dev/null) =~ /MRGIT/_git/ReachClient ]]
then
    paths='Web/scripts Web/typescript Web/scripts/OPEN_SOURCE_SOFTWARE/typescriptDefinitions Web/node_modules/typescript/lib/lib.*.d.ts'
    excludes="--exclude=OPEN_SOURCE_SOFTWARE --exclude=napa"
fi

# Use git repo's base directory if applicable.
basedir="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"


#   MAIN
#
(maketags && alert) &
