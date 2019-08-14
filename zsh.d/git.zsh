#
#   git aliases (don't contain pipes; not re-used in functions)
#
alias gd='git diff'
alias gdt='git difftool'
alias gf='git fetch -p'
alias gp='git pull -p --ff-only'
alias gu='git gui browser'
alias gr='git remote -v'
alias gsa='git stash apply'
alias gsd='git stash drop'
alias gsl='git stash list'
alias gsp='git stash pop'
alias gss='git stash show'
alias gsv='git stash save'

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
    git branch --color -v $@ | cut -c 1-$(tput cols)
}

gb() {
    gbb $@ | egrep -v "^. old/"
}

#
#   FZF GIT WIDGETS
#

# Select git modified file(s).
fzf-git-modified-widget() {
    LBUFFER+="$(git status --short | fzf --exit-0 --preview 'git diff --color {2}'| awk '{print $2}' | xargs)"
    zle redisplay
}
zle -N fzf-git-modified-widget
bindkey '^g^g' fzf-git-modified-widget # Pick changed file in git.

__git-branches() {
    git for-each-ref --format='%(refname:short)' $1
}

__fzf_preview_gitshow() {
    fzf --multi --preview='echo "branch: {}"; git show --color --decorate --format=fuller --stat --patch {}' $@
}

# Select a local git branch.
fzf-gitbranches-widget() {
    LBUFFER+="$(__git-branches refs/heads/ | __fzf_preview_gitshow -q '!old/ ' )"
    zle redisplay
}
zle -N fzf-gitbranches-widget
bindkey '^g^b' fzf-gitbranches-widget # Pick a git local branch.

# Select any git branch.
fzf-git-branches-all-widget() {
    LBUFFER+="$(__git-branches | __fzf_preview_gitshow -q '!origin/Dev/releases/ !/submit/request- !old/ ')"
    zle redisplay
}
zle -N fzf-git-branches-all-widget
bindkey '^g^b^b' fzf-git-branches-all-widget # Pick any git branch.

# Select a git stash
fzf-git-stash-widget() {
    LBUFFER+="$(git stash list | cut -d : -f 1 | fzf --preview 'git stash show --color -p {}' --preview-window='right:80%')"
    zle redisplay
}
zle -N fzf-git-stash-widget
bindkey '^g^t' fzf-git-stash-widget # Pick a git stash.
