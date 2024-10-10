# https://volta.sh
# To upgrade volta:
#   brew upgrade volta
#   volta setup
#
# export VOLTA_HOME="$HOME/.volta";path=("$VOLTA_HOME/bin" $path)
if (whence volta >/dev/null) {
    if [[ -d "$HOME/.volta" ]]
    then
        export VOLTA_HOME="$HOME/.volta"
        # path=("$VOLTA_HOME/bin" $path)
        # ^- Already added to `/etc/paths`
    fi

    source "$dotfiles/zsh.d/vendor/volta-completions.zsh"
}

# Just use `volta list all`
# list-volta-packages() {
#     rg --no-filename --max-count 2 --no-line-number \
#         -o '"(name|version)": ".+?"' \
#         ~/.volta/tools/image/packages/*/lib/node_modules/*/package.json
# }

whence node npm >/dev/null || return

# If run with cwd in a monorepo, we get "This command does not support
# workspaces." error. Appears fixed in `npm 9.2.0`
# https://github.com/npm/cli/commit/dfd5d461e0ee2163e210cc136d2bb7873dfeb363
(cd && source <(npm completion))

# grep -q ./node_modules/.bin /etc/paths || path=(./node_modules/.bin $path)

alias nn='npm run'
alias yy='yarn run'

alias nnci='npm ci && never_index_artifacts'

npm-home() {
    # Emulate `npm home` for packages that only list GitHub (and similar)
    # repository urls.
    open "$(npm info "$1" repository.url | perl -pne 's%^git@%https://%g and s%\.com:%.com/% and s%\.git%%')"
}
