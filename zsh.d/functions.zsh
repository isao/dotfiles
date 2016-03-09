zman() {
  PAGER="less -g -s '+/^       "$1"'" man zshall
}


ql() {
	(qlmanage -p "$1" 2&>1 > /dev/null) &
}