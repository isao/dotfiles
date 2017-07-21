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
    ctags $language $excludes $ctagflags $args $paths
}

alert()
{
    osascript -e "display notification \"$basedir\" with title \"$scriptname\""
}

#   CHECKS
#
type ctags >/dev/null || err 1 "Error: you need to install ctags (brew install universal-ctags)."
[[ -f ~/.ctags ]] || err 3 "Error: you need to install ~/.ctags https://git.io/vDE8C"

#   PARAMS
#

scriptname=$(basename "$0" .sh)
args=$*
ctagflags='--excmd=number --tag-relative=no --fields=+a+m+n+S --recurse'
excludes='--exclude=node_modules --exclude=.git'
language=
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
    language='--languages=typescript'
    excludes="$excludes --exclude=OPEN_SOURCE_SOFTWARE --exclude=napa"
elif [[ -d 'node_modules/typescript/lib' ]]
then
    paths='node_modules/typescript/lib/lib.*.d.ts'
fi

# Use git repo's base directory if applicable.
basedir="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"


#   MAIN
#
(maketags && alert) &
