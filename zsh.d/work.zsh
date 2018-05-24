# to make stupid "BuildTools" git hooks work
path+=(~/work/repos/BuildTools/GitHelpers)

cdpath+=($HOME/work $HOME/work/repos)

# ESC I - git branch string (macro)
bindkey -s '\ei' 'users/eisayag/'

# ESC U R - ReachClient Url picker
type fzf rg >/dev/null && [[ -r /Users/isao/Dropbox/Notes/reachclient-urls.txt ]] && {
    fzf-reachclienturls-widget() {
        LBUFFER+="$(fzf < /Users/isao/Dropbox/Notes/reachclient-urls.txt)"
        zle redisplay
    }
    zle -N fzf-reachclienturls-widget
    bindkey '\euu' fzf-reachclienturls-widget
}

# Open browser to TFS commit
tfs-commit() {
    local sha=$(git log -1 --format='%H' $1)
    [[ -z $1 ]] && echo 'No git commit sha provided, defaulting to head' >&2
    open "http://tfsmr.mr.ericsson.se:8080/tfs/IEB/MRGIT/_git/ReachClient/commit/$sha"
}

# Open browser to the Jira bug/task/story using the last number in the branch
# name. Number must be prefixed with "-". i.e. invoking in a repo at branch
# named "abc-s90-1234", opens browser to jira bug MF-1234.
tfs-bug-from-branch-name() {
    local num=$(git rev-parse --abbrev-ref HEAD | egrep -o -- '-[0-9]+$')
    open "https://jira-fe-p01.mr.ericsson.se:8443/browse/MF$num"
}

# Open browser to TFS view of current working directory.
tfs-cwd() {
    local branch=$(git rev-parse --abbrev-ref HEAD)
    local subdir=$(git rev-parse --show-prefix)
    open "http://tfsmr.mr.ericsson.se:8080/tfs/IEB/MRGIT/_git/ReachClient?path=$subdir&version=GB$branch"
}

# Open browser to the new PR web interface for the current branch.
tfs-pr() {
    local branch=$(git rev-parse --abbrev-ref HEAD)
    open "http://tfsmr.mr.ericsson.se:8080/tfs/IEB/MRGIT/_git/ReachClient/pullrequestcreate?sourceRef=$branch&targetRef=dev/master"
}

# Do git-request-submit with basename of branch and time for the request-name.
git-submit() {
    local name=$(basename $(git rev-parse --abbrev-ref HEAD))
    local suffix=$(date +%H%M%S)
    set -x
    git-request-submit -v $@ $name-$suffix
}

# Do git-submit after linting and running unit tests.
git-submit-verified() {
    set -ex
    gulp tslint
    npm test
    git-submit $@
}
