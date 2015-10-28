#!/bin/bash -e

# this script symlinks all dot files here to $HOME adding a leading dot.
# (run from anywhere, $CWD is not important).

# full path to this file's directory; i.e. /Users/isao/Repos/dotfiles
thisdir=$(dirname "$0")
abspath=$(cd "$thisdir" && git rev-parse --show-toplevel)

# get list of dotfiles
filelist=$(/bin/ls -1 "$abspath")

# -s symbolic, -v verbose, -i prompt before replacing anything
link="ln -svi"

cd "$HOME"
for i in $filelist
do
  if [[ -f "$abspath/$i" ]]
  then
    $link "$abspath/$i" ".$i"
  fi
done
