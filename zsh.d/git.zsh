#
#   git aliases (don't contain pipes; not re-used in functions)
#
alias gd='git diff'
alias gdt='git difftool'
alias gf='git fetch -p --tags'
alias gp='git pull -p --tags --ff-only'
alias gu='git gui browser'
alias gr='git remote -v'
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

ggg() {
    gg --ignored $@
}

gggg() {
    # summarize & count ignored pathnames by their first two path segments
    ggg $@ | cut -c 4- | cut -d / -f 1-2 | sort | uniq -c
}

#
#   git branch
#
gbb() {
    git branch --sort -authordate --color -v $@ | cut -c 1-$(tput cols)
}

gb() {
    gbb $@ | egrep -v "^. old/"
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

# Select a commit
fzf-git-pick-commit() {
    LBUFFER+="$(git log --oneline --no-merges | fzf --preview='git show --color -p {1}' | awk '{ print $1 }' | xargs echo)"
    zle redisplay
}
zle -N fzf-git-pick-commit
bindkey '^g^p' fzf-git-pick-commit # Pick a git commit.
