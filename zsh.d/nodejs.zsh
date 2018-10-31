hash node npm >/dev/null || return

alias nn='npm run'

# Completion for `npm run` scripts
function nn-complete {
    npm run | egrep -o '^  \S+' | xargs
}
compdef nn-complete nn    

# Functions

link-node6() {
    brew unlink node
    brew link --force node@6
}

link-node() {
    brew unlink node@6
    brew link node
}
