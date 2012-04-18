#!/bin/sh -e

#find git dirs from command line arguments; use cwd by default
gitdirs=${@:-.}

#get full path to this script's dir
hookdir=`cd $(dirname $0) && pwd`

#space delimited list of hook scripts relative to $hookdir
hookfiles='post-commit'

#find hook dirs to symlink to post-commit from
for i in `find $gitdirs -type d -path '*/.git/hooks' -maxdepth 2`
do
  (
    cd $i && pwd
    for j in $hookfiles
    do
      ln -svfi $hookdir/$j
    done
  )
done
