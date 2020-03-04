hash node npm >& /dev/null || return

path=(node_modules/.bin $path)

alias nn='npm run'

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
