#!/bin/bash -e

#glob to match files to symlink from this dir to $HOME
dotglob='dot-*'

#full path to this file's directory; i.e. /Users/isao/Repos/1st/dotfiles
dotpath=`(cd $(dirname $0) && pwd)`

#get filenames to symlink (without path parts)
filelist=`(cd $dotpath && ls $dotglob)`

#replace home dir path with .; i.e. ./Repos/1st/dotfiles
relpath=${dotpath/$HOME/.}

#the cd and relpath stuff is to get nice short symlink references
cd $HOME
for i in $filelist
do
  ln -svi $relpath/$i ${i/dot-/.}
done

#one-offs
[[ -d .ssh ]] && ln -svi $relpath/dotssh-config .ssh/config
[[ -d .subversion ]] && ln -svi $relpath/dotsvn-config .subversion/config
