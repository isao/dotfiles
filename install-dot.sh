#!/bin/sh -e

#config file dir
dotdir=~/.dotfiles

err()
{
	echo "$1 exiting"
	exit
}

symlink_dotstar()
{
	echo '- symlink dot-* files to ~'
	{
		#cd here to so file list from dot-* glob doesn't have leading path parts
		cd $dotdir
		for i in dot-*
		do
			#replace dot- with . in filenames
			ln -svi $dotdir/$i ~/${i/dot-/.}
			#for cmd: ln -svi .dotfiles/dot-gitconfig /Users/isao/.gitconfig
			#link is: ~/.gitconfig -> .dotfiles/dot-gitconfig
		done
	}
}

[[ ! -d $dotdir ]] && "install files should be at '$dotdir' but they're not"

symlink_dotstar
ln -svi $dotdir/dotssh-config ~/.ssh/config
ln -svi $dotdir/dotsvn-config ~/.subversion/config
ln -svi $dotdir/php-* \
	`php -i |grep 'this dir for additional .ini files' |awk '{print $NF}'`

echo "paste these lines at the end of httpd.conf, or copy/symlink the files where they will"
echo "be included:"
echo
for i in $dotdir/httpd-*
do
	echo "Include $i"
done
echo
