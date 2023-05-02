# https://volta.sh
# To upgrade volta:
#   brew upgrade volta
#   volta setup
#
# export VOLTA_HOME="$HOME/.volta";path=("$VOLTA_HOME/bin" $path)
if [[ -d "$HOME/.volta" ]]
then
    export VOLTA_HOME="$HOME/.volta"
    # path=("$VOLTA_HOME/bin" $path)
    # ^- Already added to `/etc/paths`
    # source <(volta completions 'zsh')
    # ^- errors -> _arguments:comparguments:325: can only be called from completion function
fi

whence node npm >/dev/null || return

# If run with cwd in a monorepo, we get "This command does not support
# workspaces." error. Appears fixed in `npm 9.2.0`
# https://github.com/npm/cli/commit/dfd5d461e0ee2163e210cc136d2bb7873dfeb363
(cd && source <(npm completion))

# grep -q ./node_modules/.bin /etc/paths || path=(./node_modules/.bin $path)

alias nn='npm run'

alias nnci='npm ci && never_index_artifacts'

npm-home() {
    # Emulate `npm home` for packages that only list GitHub (and similar)
    # repository urls.
    open "$(npm info "$1" repository.url | perl -pne 's%^git@%https://%g and s%\.com:%.com/% and s%\.git%%')"
}
