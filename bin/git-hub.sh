#!/bin/bash -e

github_remote=${GIT_HUB_REMOTE:-'origin'}
default_branch=${GIT_HUB_DEFAULT_BRANCH:-'main'}

help() {
    cat <<HELP >&2
Usage: git hub [command] [arg1, arg2]

Open a GitHub page based on your current working directory, and git remote url.

Commands:
    (no args)                   Open the GitHub page for current branch and
                                current directory.

    <pathname>                  Open the GitHub page for current branch and
                                optional pathname.

    blame <file> [sha] [query]  Open the GitHub blame for file, optional git
                                branch/revision, and url suffix (i.e. "#L9").

    compare [file] [branchname] Open the GitHub compare page for branch.

    log [pathname]              Open the GitHub commits page for current branch
                                and optional pathname.

    pr                          Open the GitHub pull request page for the
                                current branch.

    prs [github-username]       Open the GitHub pull requests page.

    sha <sha>                   Open the GitHub commit view for sha or HEAD.

HELP
}

err() {
    echo "$1" >&2
    exit "$2"
}

repo_url() {
    # Get the GitHub repo url from the git remote url.
    git remote get-url "$github_remote" --push \
        | perl -pne 's%^git@%https://%g and s%\.com:%.com/% and s%\.git%%'
}

branch_was_pushed() {
    git ls-remote --heads --exit-code "$github_remote" "$1"
}

remote_branch() {
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
    open "$(repo_url)/commits/$(remote_branch)/$(pathname "$1")"
}

file_or_dir_view() {
    # GitHub will re-direct from /tree/ to /blob/ as needed.
    open "$(repo_url)/tree/$(remote_branch)/$(pathname "$1")$2"
}

blame() {
    # TODO convert tree-ish to sha.
    open "$(repo_url)/blame/${2:-$(remote_branch)}/$(pathname "$1")$3"
}

compare() {
    open "$(repo_url)/compare/${2:-$(remote_branch)}/$(pathname "$1")"
}

pull_request() {
    local branch
    branch=$(git branch --show-current)

    [[ $branch =~ ^(main|master|release/.+)$ ]] && \
        err "Exiting, branch '$branch' is special." 3

    git push -u
    open "$(repo_url)/pull/new/$branch"
}

pull_requests() {
    open "$(repo_url)/pulls/$1"
}

sha() {
    open "$(repo_url)/commit/${1:-HEAD}"
}

git rev-parse 2>/dev/null || err "Exiting, there is no git repo here." 1

case $1 in
    'blame' )
        blame "$2" "$3" "$4"
        ;;
    'compare' )
        compare "$2" "$3"
        ;;
    'log' )
        log "$2"
        ;;
    'pr' )
        pull_request
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
        file_or_dir_view "$1" "$2"
        ;;
    * )
        if [[ -e "$1" ]]
        then
            file_or_dir_view "$1" "$2"
        else
            err "Unrecognized command '$1'. Try 'git-hub help'." 1
        fi
        ;;
esac
