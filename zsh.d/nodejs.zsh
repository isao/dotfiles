
alias nn='npm run'

# Completion for `npm run` scripts
if (type npr >/dev/null) {
    function npr-complete {
        npm run | egrep -o '^  \S+' | xargs echo
    }
    compdef nn-complete npr    
}

# Functions

link-node6() {
    brew unlink node
    brew link --force node@6
}

link-node() {
    brew unlink node@6
    brew link node
}
