whence node npm >/dev/null || return

source <(npm completion)

path=(node_modules/.bin $path)

alias nn='npm run'

alias nnci='npm ci && never_index_artifacts'

# https://volta.sh
if [[ -d "$HOME/.volta" ]]
then
    export VOLTA_HOME="$HOME/.volta"
    path=("$VOLTA_HOME/bin" $path)
    # source <(volta completions 'zsh')
    # ^- errors -> _arguments:comparguments:325: can only be called from completion function
fi
