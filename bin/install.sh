#!/bin/bash -e

# Usage: ~/repos/dotfile/bin/install.sh
# (run from anywhere, $CWD is not important).

# full path to this file's directory; i.e. /Users/isao/repos/dotfiles
thisdir=$(dirname "$0")
abspath=$(cd "$thisdir" && git rev-parse --show-toplevel)

# -s symbolic, -v verbose, -i prompt before replacing anything
link="ln -svf"

# Symlink to all files in ./ from $HOME, adding a leading dot.
cd "$HOME"
for i in $(/bin/ls -1 "$abspath")
do
  if [[ -f "$abspath/$i" ]]
  then
    $link "$abspath/$i" ".$i"
  fi
done

# Symlink to all files in ./bin from /usr/local/bin, removing the ".sh"
cd /usr/local/bin
for i in $(/bin/ls -1 "$abspath"/bin/*.sh)
do
  if [[ $(basename "$0") != $(basename "$i") ]]
  then
    $link "$i" $(basename "$i" .sh)
  fi
done
