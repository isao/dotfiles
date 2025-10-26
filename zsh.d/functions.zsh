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
    man $1 | col -bx
}

xman() {
    open "x-man-page://$1"
}

never_index_artifacts() {
    find . \
        -type d \
        \( -name node_modules -o -name dist -o -name "dist-*" -o -name coverage -o -name artifacts \) \
        -maxdepth 2 \
        -prune \
        -print \
        -execdir touch {}/.metadata_never_index \;
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

# `cd` to the frontmost Finder window.
cdfinder() {
    cd -P "$(finderpath)"
}

# `cd` up to next package or git repo root directory.
cdup() {
    local lastPwd
    while
        lastPwd="$PWD"
        cd ..
        [[ ! ( -f package.json || -d .git) && "$lastPwd" != "$PWD" ]]
    do true
    done
}

# find a file from current directory until filesystem root
# https://github.com/sgeb/dotfiles/tree/master/zsh/functions
upfind() {
    dir="`pwd`"
    while [ "$dir" != "/" ]
    do
        p=`find "$dir" -maxdepth 1 -name "$1"`
        if [ ! -z "$p" ]; then
            echo "$p"
            return
        fi
        dir="`dirname "$dir"`"
    done
}

# https://github.com/sgeb/dotfiles/tree/master/zsh/functions
mkcd() {
    mkdir -p "$1" && cd "$1"
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

# https://stackoverflow.com/a/7222469/8947435
# To ignore network mounts and optical disks, use:
# osascript -e 'tell application "Finder" to eject (every disk whose ejectable is true and local volume is true and free space is not equal to 0)'
eject-all() {
    osascript -e 'tell application "Finder" to get (every disk whose ejectable is true)'
    osascript -e 'tell application "Finder" to eject (every disk whose ejectable is true)'
}

weeknum() {
    date +"%yw%V"
    # Outputs "19w26"
}

darkmode() {
    osascript -e 'tell application "System Events" to tell appearance preferences to set dark mode to not dark mode'
}

# Only show outdated leaves that aren't pinned.
brew-outdated() {
    join <(brew outdated) <(comm -13 <(brew ls --pinned) <(brew leaves))
}

# Find wordle words that match a regex
wordle() {
   rg --pcre2 "$@" ~/Documents/wordle-words.txt
}

# Filter stdin for lines containing all letters of any of the passed-in arguments
with() {
  rg --pcre2 "$(printf '(?=.*%s)' ${(s::)${(j::)@}})"
}
#   - printf formats and prints text
#   - '(?=.*%s)' is the format string where `%s` gets replaced by each letter
#   - ${(s::)@} splits the argument into characters
#   - ${(j::)@} joins each argument into a string without spaces
#
#   Examples (spaces are not significant):
#   with a d g
#   with adg
#
#   Which outputs:
#   rg --pcre2 "(?=.*a)(?=.*d)(?=.*g)"
#
#   The regex breakdown:
#   - (?=.*a) - positive lookahead: line must contain "a" somewhere
#   - (?=.*d) - positive lookahead: line must contain "d" somewhere
#   - (?=.*g) - positive lookahead: line must contain "g" somewhere

# Filter stdin for lines NOT containing any letters of any of the passed-in arguments
without() {
    local joined="${(j::)@}"  # join arguments with nothing
    rg -v "[$joined]"
}

letter_frequency() {
    fold -w1 | sort | uniq -c | sort -rn
}
