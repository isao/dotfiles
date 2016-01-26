#!/bin/sh -e

#find git dirs from command line arguments; use cwd by default
gitdirs=${@:-.}

#get full path to this script's dir
if [[ -L $0 ]]
then
    thisscript=$(readlink $0)
else
    thisscript=$0
fi
hookdir=$(cd $(dirname $thisscript) && pwd)

#space delimited list of hook scripts relative to $hookdir
#hookfiles='pre-commit post-commit'
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
