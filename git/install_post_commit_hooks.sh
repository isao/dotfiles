#!/bin/sh -e

[[ -z $@ ]] && {
  echo "missing git repo path(s)" >&2
  exit 9
}

#get full path to this dir
file_to_hook=`(cd $(dirname $0) && pwd)`/post-commit

#find hook dirs to symlink to post-commit from
for i in `find $@ -type d -path '*/.git/hooks' -maxdepth 2`
do
  (cd $i && pwd && ln -svfi $file_to_hook)
done
