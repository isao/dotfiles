#!/bin/bash -e

github_remote=${GITHUB_REMOTE:-'origin'}
default_branch=${DEFAULT_BRANCH:-'master'}

help() {
    cat <<HELP >&2
Usage: git hub [command] [arg1, arg2]

Open a GitHub page based on your current working directory, and git remote url.

Must run from the working directory of a GitHub repo.

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

repo_url() {
    # Get the GitHub repo url from the git remote url.
    git remote get-url "$github_remote" --push \
        | perl -pne 's%^git@%https://%g and s%\.com:%.com/% and s%\.git%%'
}

branch_was_pushed() {
    git ls-remote --heads --exit-code "$github_remote" "$1"
}

branchname() {
    local branch
    branch=$(git branch --show-current)

    if [[ -n $branch && $(branch_was_pushed "$branch") ]]
    then
        echo "$branch"
    else
        echo "$default_branch"
    fi
}

pathname() {
    if [[ -f "$1" ]]
    then
        git ls-tree --full-name --name-only HEAD "$1"
    else
        (cd "$1" && git rev-parse --show-prefix)
    fi
}

log() {
    open "$(repo_url)/commits/$(branchname)/$(pathname "$1")"
}

file_or_dir_view() {
    # GitHub.com will re-direct from /tree/ to /blob/ if needed.
    open "$(repo_url)/tree/$(branchname)/$(pathname "$1")"
}

blame() {
    # TODO convert tree-ish to sha.
    open "$(repo_url)/blame/${2:-HEAD}/$(pathname "$1")"
}

compare() {
    open "$(repo_url)/compare/${2:-$(branchname)}/$(pathname "$1")"
}

pull_request() {
    git push -u
    open "$(repo_url)/pull/new/$(branchname)"
}

pull_requests() {
    open "$(repo_url)/pulls/$1"
}

sha() {
    open "$(repo_url)/commit/${1:-HEAD}"
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
        pull_requests "$2"
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
