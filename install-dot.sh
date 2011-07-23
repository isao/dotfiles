#!/bin/bash -e

#glob to match files to symlink from this dir to $HOME
dotglob='dot-*'

#full path to this file's directory; i.e. /Users/isao/Repos/1st/dotfiles
dotpath=`(cd $(dirname $0) && pwd)`

#get list of dotfiles
filelist=`(cd $dotpath && ls $dotglob)`

#get relative path from ~ to this file's directory to make short symlinks
relpath=${dotpath/$HOME/.}

cd $HOME
for i in $filelist
do
  #replace "dot-" with "." for target of symlink; prompt before overwriting
  #i.e. ln -svi ./Repos/dotfiles/dot-gitignore .gitignore
  ln -svfi $relpath/$i ${i/dot-/.}
done

#one-offs
[[ -d .ssh ]] && ln -svfi $relpath/dotssh-config .ssh/config
[[ -d .subversion ]] && ln -svfi $relpath/dotsvn-config .subversion/config
