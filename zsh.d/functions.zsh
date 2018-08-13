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

# Quicklook
ql() {
    qlmanage -p "$1" > /dev/null 2>&1
}

# Get path to the active Finder window.
finderpath() {
    osascript <<-EOF
        tell application "Finder"
            if first window exists then
                target of first window as alias
            else
                get desktop as alias
            end if
            POSIX path of result
        end tell
EOF
}

cdfinder() {
    cd -P "$(finderpath)"
}

upfind() {
    # find a file from current directory until filesystem root
    # https://github.com/sgeb/dotfiles/tree/master/zsh/functions
    dir="`pwd`"
    while [ "$dir" != "/" ]; do
        p=`find "$dir" -maxdepth 1 -name "$1"`
        if [ ! -z "$p" ]; then
            echo "$p"
            return
        fi
        dir="`dirname "$dir"`"
    done
}

mkcd() {
    # https://github.com/sgeb/dotfiles/tree/master/zsh/functions
    mkdir -p "$1"
    cd "$1"
}

gohome() {
    adb disconnect &
    echo "will sleep in 5 seconds, turn off keyboard and mouse now."
    sleep 5
    osascript -e 'tell application "Finder" to sleep'
}

canary() {
    open -a 'Google Chrome Canary' --args --ignore-certificate-errors --enable-precise-memory-info $@
}
