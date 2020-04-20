whence node npm >/dev/null || return

path=($path node_modules/.bin)

alias nn='npm run'

alias nnci='npm ci && never_index_artifacts'

function nni() {
    npm install $@
    never_index_artifacts
}

# Completion for `npm run` scripts
function nn-complete {
    npm run | egrep -o '^  \S+' | xargs
}
compdef nn-complete nn    

# Functions

link-node10() {
    brew unlink node
    brew link --force node@10
}

link-node() {
    brew unlink node@10
    brew link node
}

source <(npm completion)
