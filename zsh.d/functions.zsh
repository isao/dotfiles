zman() {
  PAGER="less -g -s '+/^       "$1"'" man zshall
}

dict() {
	curl -s "dict://dict.org/d:$1" | egrep -v '^[0-9]{3} .*|^\.'
}

word() {
	grep "$1" /usr/share/dict/words
}

man2txt() {
	man $* | col -b
}

manx() {
	open "x-man-page://$1"
}

# Mac OSX
rmmacmeta() {
	find ${@:-.} \( -name '.DS_Store' -or -name '._*' \) -exec rm -v '{}' \;
}

ql() {
	(qlmanage -p "$1" 2&>1 > /dev/null) &
}

bbproj() {
	open "~/Dropbox/Documents/bbproj/$1"
}
