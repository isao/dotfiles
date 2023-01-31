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

source <(npm completion)

# grep -q ./node_modules/.bin /etc/paths || path=(./node_modules/.bin $path)

alias nn='npm run'

alias nnci='npm ci && never_index_artifacts'
