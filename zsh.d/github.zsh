git-repo-url() {
    # Get the GitHub repo url from the git remote url, assuming `origin`.
    git remote get-url origin --push \
        | perl -pne 's%^git@%https://%g and s%\.com:%.com/% and s%\.git%%'
}

ghb() {
    # GitHub: commits for the $CWD branch
    open "$(git-repo-url)/commits/$(git branch --show-current)"
}

ghpr() {
    # GitHub: open a new pull request
    open "$(git-repo-url)/pull/new/$(git branch --show-current)"
}

ghprs() {
    # GitHub: see the open pull requests
    open "$(git-repo-url)/pulls"
}

ghcmp() {
    # GitHub: compare current branch
    open "$(git-repo-url)/compare/$(git branch --show-current)"
}

ghc() {
    # GitHub: show commit for sha
    open "$(git-repo-url)/commit/${1:-HEAD}"
}
