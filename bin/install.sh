#!/bin/bash -e

# Usage: ./install.sh
# (run from anywhere, $CWD is not important).

bin_dir="${HOMEBREW_PREFIX:-/usr/local}/bin"

# full path to this file's directory; i.e. /Users/isao/repos/dotfiles
thisdir=$(dirname "$0")
abspath=$(cd "$thisdir" && git rev-parse --show-toplevel)

# -s symbolic, -v verbose, -i prompt before replacing anything
link="ln -svf"

# Install the dotfiles.
# Symlink to all files in ./ from $HOME, adding a leading dot.
cd "$HOME"
for i in $(/bin/ls -1 "$abspath")
do
  if [[ -f "$abspath/$i" ]]
  then
    $link "$abspath/$i" ".$i"
  fi
done

# Special case: dot-directory
$link "$abspath/ctags.d" .ctags.d

# Install some scripts.
# Symlink to all files in ./bin from $bin_dir, removing the ".sh"
cd $bin_dir
for i in "$abspath"/bin/*.sh
do
  if [[ $(basename "$0") != $(basename "$i") ]]
  then
    $link "$i" $(basename "$i" .sh)
  fi
done

type brew >& /dev/null && brew cleanup --prune-prefix
