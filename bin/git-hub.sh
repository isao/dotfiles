#!/bin/sh -e

help() {
    clear
    cat <<HELP
Usage: git hub [command] [arg1, arg2]

Open a GitHub page based on your current working directory, and the current repo's remote url. Must run from a git working directory.

Commands:
    (no args)                   GitHub page for current branch and directory.
    <pathname>                  GitHub page for current branch and pathname.
    blame <file> [sha]          GitHub blame for file.
    compare [file] [branchname] GitHub compare branch page for branch.
    log [pathname]              GitHub commits page for current branch and pathname.
    pr                          GitHub pull request page for the current branch.
    prs                         GitHub pull requests page.
    sha [sha]                   GitHub commit view for sha or HEAD.

HELP
}

url() {
    # Get the GitHub repo url from the git remote url, assuming `origin`.
    git remote get-url origin --push \
        | perl -pne 's%^git@%https://%g and s%\.com:%.com/% and s%\.git%%'
}

pathname() {
    if [[ -f "$1" ]]
    then
        git ls-tree --full-name --name-only HEAD "$1"
    else
        (cd "$1" && git rev-parse --show-prefix)
    fi
}

branchname() {
    git branch --show-current
}

log() {
    open "$(url)/commits/$(branchname)/$(pathname $1)"
}

file_or_dir_view() {
    # GitHub.com will re-direct from /tree/ to /blob/ if needed.
    open "$(url)/tree/$(branchname)/$(pathname $1)"
}

blame() {
    # TODO convert tree-ish to sha.
    open "$(url)/blame/${2:-HEAD}/$(pathname $1)"
}

compare() {
    set -x
    open "$(url)/compare/${2:-$(branchname)}/$(pathname $1)"
}

pull_request() {
    git push -u
    open "$(url)/pull/new/$(branchname)"
}

pull_requests() {
    open "$(url)/pulls"
}

sha() {
    open "$(url)/commit/${1:-HEAD}"
}

case $1 in
    'blame' )
        blame "$2" "$3"
        ;;
    'compare' )
        compare "$2" "$3"
        ;;
    'log' )
        log "$2"
        ;;
    'pr' )
        pull_request "$2"
        ;;
    'prs' )
        pull_requests
        ;;
    'sha' )
        sha "$2"
        ;;
    'help' )
        help
        ;;
    '' )
        file_or_dir_view
        ;;
    * )
        if [[ -e "$1" ]]
        then
            file_or_dir_view "$1"
        else
            echo "Unrecognized command '$1'. Try 'git-hub help'."
        fi
        ;;
esac
