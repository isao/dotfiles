#
#   git aliases (don't contain pipes; not re-used in functions)
#
alias gd='git diff'
alias gdt='git difftool'
alias gf='git fetch --prune --tags'
alias gp='git pull --prune --tags --ff-only'
alias gr='git remote -v'
alias gsw='git switch'
alias gsa='git stash apply'
alias gsd='git stash drop'
alias gsl='git stash list'
alias gsp='git stash pop'
alias gss='git stash show'
alias gsv='git stash save --include-untracked'

#
#   tig
#
alias tgs='tig status'
alias tgl='tig log'
alias tgb='tig blame -w -C'

#
#   git status
#
gg() {
    git status --branch --short $@
}

# git ignored files
ggi() {
    gg --ignored $@
}

# git ignored files (summarized by their first two path segments, with counts)
ggii() {
    ggi $@ | cut -c 4- | cut -d / -f 1-2 | sort | uniq -c
}

# git branch (sorted by date, truncated to terminal width)
gbb() {
    git branch --sort -authordate --color -v $@ | cut -c 1-$COLUMNS
}

# git branch (filtering out ones whose names begin with "old/")
gb() {
    gbb $@ | egrep -v "^. old/"
}

# git branch (with -v for remote tracking info)
gbv() {
    gb -v $@
}

# git branch (sorted by branch name)
gbs() {
    gb --sort=refname $@
}

# fetch and switch to an upstream GitHub pull request branch.
git-fetch-pr() {
    git fetch up "pull/$1/head:pr$1" && git switch "pr$1"
}


#
#   FZF GIT WIDGETS
#

# Select git modified file(s).
fzf-git-modified-widget() {
    LBUFFER+="$(git status --short | fzf -n2 --preview 'git diff --color {2}' --exit-0 | awk '{print $2}' | xargs)"
    zle redisplay
}
zle -N fzf-git-modified-widget
bindkey '^g^g' fzf-git-modified-widget # Pick changed file in git.

__git-branches() {
    git for-each-ref --format='%(refname:short)' --sort -authordate $1
}

__fzf_preview_gitlog_branch() {
    fzf --multi --preview='echo "branch: {}"; git log -9 --color --decorate --format=fuller --stat {}' $@
}

# Select a local git branch.
fzf-gitbranches-widget() {
    LBUFFER+="$(__git-branches refs/heads/ | __fzf_preview_gitlog_branch  -q '!old/ ')"
    zle redisplay
}
zle -N fzf-gitbranches-widget
bindkey '^g^b' fzf-gitbranches-widget # Pick a git local branch.

# Select any git branch.
fzf-git-branches-all-widget() {
    LBUFFER+="$(__git-branches | __fzf_preview_gitlog_branch)"
    zle redisplay
}
zle -N fzf-git-branches-all-widget
bindkey '^g^b^b' fzf-git-branches-all-widget # Pick any git branch.

# Select a git stash
fzf-git-stash-widget() {
    # % git stash list
    # stash@{0}: On some-branch-name: some-stash-name
    # % git stash list  | cut -d : -f 1,3
    # stash@{0}: some-stash-name
    # % git stash list  | cut -d : -f 1
    # stash@{0}
    LBUFFER+="$(git stash list | cut -d : -f 1,3 | fzf --preview 'git stash show --color -p $(echo {} | cut -d : -f 1)' --preview-window=right:60% | cut -d : -f 1)"
    zle redisplay
}
zle -N fzf-git-stash-widget
bindkey '^g^t' fzf-git-stash-widget # Pick a git stash.

# git log -> fzf with preview. Allows fuzzy finding by email, sha, or commit
# subject. returns selected sha(s)
git-log-fzf() {
    # git log format info:
    # %C(___)   color
    # %h        short commit sha
    # %s        commit subject
    # %al       author email local-part (the part before the @ sign)
    git log --format='%C(auto)%h %s %C(blue)@%al' --color=always $@ \
        | fzf --ansi --no-sort --preview='git show --color --stat --decorate --pretty=fuller -p {1}' \
        | awk '{ print $1 }' \
        | xargs
}

# Select a commit from any branch with fzf, allowing fuzzy matching on the
# author email local-part.
fzf-git-pick-commit() {
    LBUFFER+="$(git-log-fzf --all --no-merges -9999)"
    zle redisplay
}
zle -N fzf-git-pick-commit
bindkey '^g^p' fzf-git-pick-commit # Pick a git commit from any branch to cherry-pick

# Select a commit since the last merge to --fixup or --squash.
fzf-git-fixup-commit() {
    LBUFFER+="$(git-log-fzf $(git log --merges --format=%h -1)..HEAD)"
    zle redisplay
}
zle -N fzf-git-fixup-commit
bindkey '^g^f' fzf-git-fixup-commit # Pick a git commit made since the last merge to --fixup or --squash.
