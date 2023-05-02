#!/bin/bash
set -eo pipefail

github_remote=${GIT_HUB_REMOTE:-'origin'}
default_branch=${GIT_HUB_DEFAULT_BRANCH:-'main'}

help() {
    cat <<HELP
Usage: git hub [command] [arg1, arg2]

Open a GitHub page based on your current working directory, and git remote url.

Commands:
    (no args)                   Open the GitHub page for current branch and
                                current directory.

    <pathname> [suffix]         Open the GitHub page for current branch and
                                specified pathname. Optional url suffix (i.e.
                                "#L8-L9" will highlight lines 8-9).

    blame <file> [ref] [suffix] Open the GitHub blame for file. Optional git
                                sha/tag/branch, and url suffix (i.e. "#L8-L9").

    compare [branchname]        Open the GitHub compare page for branch.

    log [pathname]              Open the GitHub commits for current branch and
                                optional pathname.

    pr                          Open the GitHub pull request for the current
                                branch, if it exists on the default remote.
                                Otherwise, open the pull request creation page.

    pr <pr-number>              Open the specified GitHub pull request.

    prs                         Open the GitHub pull request listings.

    prs <github-username>       Open the GitHub pull request listings filtered
                                by author.

    sha [sha]                   Open the GitHub commit view for sha, or HEAD.

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
    open "$(repo_url)/compare/${2:-$(remote_branch)}"
}

pr_action() {
    if [[ -n "$1" ]]
    then
        pull_request_view "$1"
    else
        local branch
        branch=$(git branch --show-current)
        pull_request_view_for_branch "$branch" || pull_request_create "$branch"
    fi
}

pull_request_create() {
    [[ $1 =~ /(main|master|release/.+)$ ]] && \
        err "Error: branch '$1' is special." 3

    git push -u
    open "$(repo_url)/pull/new/$1"
}

# Show the existing PR page for the current branch, if it exists on the default
# remote. Only reliable or usable for recent or unmerged PRs. Prerequisite:
#   git config --add remote.origin.fetch +refs/pull/*/head:refs/remotes/origin/pull/*
# Based on <https://stackoverflow.com/a/17819027/8947435>.
pull_request_view_for_branch() {
    local prnum
    prnum=$(git branch \
        --remotes \
        --list "$github_remote/pull/*" \
        --sort '-authordate' \
        --contains "$github_remote/$1" \
        | rg --max-count 1 --only-matching --replace '$1' "$github_remote/pull/(\d+)") 2> /dev/null

    [[ -n "$prnum" ]] && pull_request_view "$prnum"
}

pull_request_view() {
    open "$(repo_url)/pull/$1"
}

pull_request_list() {
    open "$(repo_url)/pulls/$1"
}

sha() {
    open "$(repo_url)/commit/${1:-HEAD}"
}

git rev-parse 2>/dev/null || err "Error: there is no git repo here." 1

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
        pr_action "$2"
        ;;
    'prs' )
        pull_request_list "$2"
        ;;
    'sha' )
        sha "$2"
        ;;
    'help' )
        help | ${PAGER:-'less'}
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
