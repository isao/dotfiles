#
#   gh <https://cli.github.com/manual/>
#

# Make the PR numbers in `gh pr list` clickable.
#
# The work is done by `local/bin/gh-list-pr-linkify.sh`, which the `prs` git
# aliases call too -- git runs its `!` aliases under /bin/sh, so a script has to
# be the shared implementation rather than a function. This only points
# `gh pr list` at it. Deciding when *not* to decorate (a pipe, or an output flag
# of the caller's own) is the script's job, so it stays in one place.
#
# Everything else goes straight to the real gh. The `command` prefix is what
# keeps this from recursing into itself.
gh() {
    if [[ "${1-}" == pr && "${2-}" == list ]] && (( $+commands[gh-list-pr-linkify.sh] ))
    then
        shift 2
        gh-list-pr-linkify.sh "$@"
        return
    fi

    command gh "$@"
}
