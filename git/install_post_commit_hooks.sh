#!/bin/sh -e

file_to_hook=$(dirname $0)/post-commit

for i in `find . -type d -path '*/.git/hooks' -maxdepth 2`
do
  (cd $i && ln -svfi $file_to_hook)
done
