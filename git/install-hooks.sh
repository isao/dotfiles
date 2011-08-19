#!/bin/sh -e

[[ -z $@ ]] && {
  echo "missing git repo path(s). no hooks installed." >&2
  exit 9
}

#get full path to this dir
hookdir=`cd $(dirname $0) && pwd`

#space delimited list of hook scripts relative to $hookdir
hookfiles="post-commit"

#find hook dirs to symlink to post-commit from
for i in `find $@ -type d -path '*/.git/hooks' -maxdepth 2`
do
  (
    cd $i && pwd
    for j in $hookfiles
    do
      ln -svfi $hookdir/$j
    done
  )
done
