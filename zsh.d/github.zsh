gh-repo() {
    # Get the GitHub repo url from the git remote url, assuming `origin`.
    git remote get-url origin --push \
        | perl -pne 's%^git@%https://%g and s%\.com:%.com/% and s%\.git%%'
}

ghb() {
    # GitHub: commits for the $CWD branch
    open "$(gh-repo)/commits/${1:-$(git branch --show-current)}"
}

ghpr() {
    # GitHub: open a new pull request
    open "$(gh-repo)/pull/new/${1:-$(git branch --show-current)}"
}

ghprs() {
    # GitHub: see the open pull requests
    open "$(gh-repo)/pulls"
}

ghcmp() {
    # GitHub: compare current branch
    open "$(gh-repo)/compare/${1:-$(git branch --show-current)}"
}

ghc() {
    # GitHub: show commit for sha
    open "$(gh-repo)/commit/${1:-HEAD}"
}

