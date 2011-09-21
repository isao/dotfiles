#!/bin/bash

#glob to match files to symlink from this dir to $HOME
dotglob='dot-*'

#full path to this file's directory; i.e. /Users/isao/Repos/dotfiles
dotpath=$(cd $(dirname $0) && pwd)

#get list of dotfiles
filelist=$(cd $dotpath && ls $dotglob)

cd $HOME
for i in $filelist
do
  #replace "dot-" with "." for target of symlink; prompt before overwriting
  #i.e. ln -svi /Users/isao/Repos/dotfiles/dot-gitignore .gitignore
  ln -svfi $dotpath/$i ${i/dot-/.}
done

#one-offs; n.b. adding an extra dot to $relpath here
[[ -d .ssh ]] && ln -svfi .$relpath/dotssh-config .ssh/config
[[ -d .subversion ]] && ln -svfi .$relpath/dotsvn-config .subversion/config
