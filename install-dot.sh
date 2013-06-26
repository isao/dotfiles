#!/bin/bash

# this script symlinks all dot files here to $HOME
# renaming them with a leading dot instead of "dot-"

#full path to this file's directory; i.e. /Users/isao/Repos/dotfiles
abspath=$(cd "$(dirname $0)" && pwd)

#get list of dotfiles
filelist=$(cd "$abspath" && ls dot-*)

cd $HOME
for i in $filelist
do
  #replace "dot-" with "." for target of symlink; prompt before overwriting
  #i.e. ln -svi /Users/isao/Repos/dotfiles/dot-gitignore .gitignore
  ln -svfi "$abspath"/$i ${i/dot-/.}
done

#one-offs
[[ -d .ssh ]] && ln -svfi "$abspath"/dotssh-config .ssh/config
[[ -d .subversion ]] && ln -svfi "$abspath"/dotsvn-config .subversion/config
