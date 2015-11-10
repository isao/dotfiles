#!/bin/bash -eo pipefail

#   FUNCTIONS
#
maketags()
{
    cd "$basedir"
    /usr/local/bin/ctags $language $excludes $ctagflags $args $paths
}

alert()
{
    osascript -e "display notification \"$basedir\" with title \"$scriptname\""
}


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
    paths='Web/scripts Web/typescript Web/scripts/OPEN_SOURCE_SOFTWARE/typescriptDefinitions'
    language='--languages=typescript'
    excludes="$excludes --exclude=OPEN_SOURCE_SOFTWARE --exclude=napa"
fi

# Use git repo's base directory if applicable.
basedir="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"


#   MAIN
#
(maketags && alert) &
