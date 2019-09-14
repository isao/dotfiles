#!/bin/sh -e

help() {
    clear
    cat <<HELP
Usage: git hub <command> [arg]

Some shortcuts to open a GitHub page based on your current working directory, and the current repo's remote url.

Commands:

    blob        Show a file.
    compare     Compare branch
    log         Branch commits
    pr          Pull request
    prs         Open pull requests
    sha         Diff for a commit sha, or HEAD by default.
    tree        File or directory tree view

HELP
}

url() {
    # Get the GitHub repo url from the git remote url, assuming `origin`.
    git remote get-url origin --push \
        | perl -pne 's%^git@%https://%g and s%\.com:%.com/% and s%\.git%%'
}

log() {
    open "$(url)/commits/${1:-$(git branch --show-current)}"
}

dir() {
    open "$(url)/tree/$(git branch --show-current)/$(git rev-parse --show-prefix)"
}

blob() {
    open "$(url)/blob/$(git branch --show-current)/$(git ls-tree --full-name --name-only HEAD $1 | head -1)"
}

pull_request() {
    open "$(url)/pull/new/${1:-$(git branch --show-current)}"
}

pull_requests() {
    open "$(url)/pulls"
}

compare() {
    open "$(url)/compare/${1:-$(git branch --show-current)}"
}

sha() {
    open "$(url)/commit/${1:-HEAD}"
}

case $1 in
    'blob' )
        blob "$2"
        ;;
    'compare' )
        compare "$2"
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
    'tree' )
        dir "$2"
        ;;
    'help' )
        help
        ;;
    '' )
        dir "$2"
        ;;
    * )
        echo "Unrecognized command ”$1”, try ”git-hub help”."
        ;;
esac
