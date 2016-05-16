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
    (qlmanage -p "$1" 2&>1 > /dev/null) &
}

# bbproj() {
#     open "~/Dropbox/Documents/bbproj/$1"
# }

_BB_DOC_PATH() {
    osascript <<-EOF

    tell application "BBEdit"
        if the first text document exists then
            file of first text document as alias
            POSIX path of result
        else
            beep
        end if
    end tell

EOF
}

# Get path to the first BBEdit text document's directory.
# cwdbbedit() {
#     osascript <<-EOF
#
#     tell application "BBEdit"
#         if the first text document exists then
#             file of first text document as alias
#             tell application "Finder" to folder of result as alias
#             POSIX path of result
#         else
#             beep
#         end if
#     end tell
#
# EOF
# }

cdbbedit() {
    cd -P "$(dirname "$(_BB_DOC_PATH)")" || exit 1
}

# Get path to the active Finder window.
cwdfinder() {
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
    cd -P "$(cwdfinder)" || exit 1
}
