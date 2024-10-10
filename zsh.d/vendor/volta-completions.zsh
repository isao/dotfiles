#compdef volta

autoload -U is-at-least

_volta() {
    typeset -A opt_args
    typeset -a _arguments_options
    local ret=1

    if is-at-least 5.2; then
        _arguments_options=(-s -S -C)
    else
        _arguments_options=(-s -C)
    fi

    local context curcontext="$curcontext" state line
    _arguments "${_arguments_options[@]}" : \
'--verbose[Enables verbose diagnostics]' \
'--very-verbose[Enables trace-level diagnostics]' \
'(--verbose)--quiet[Prevents unnecessary output]' \
'-v[Prints the current version of Volta]' \
'--version[Prints the current version of Volta]' \
'-h[Print help (see more with '\''--help'\'')]' \
'--help[Print help (see more with '\''--help'\'')]' \
":: :_volta_commands" \
"*::: :->volta" \
&& ret=0
    case $state in
    (volta)
        words=($line[1] "${words[@]}")
        (( CURRENT += 1 ))
        curcontext="${curcontext%:*:*}:volta-command-$line[1]:"
        case $line[1] in
            (fetch)
_arguments "${_arguments_options[@]}" : \
'--verbose[Enables verbose diagnostics]' \
'--very-verbose[Enables trace-level diagnostics]' \
'(--verbose)--quiet[Prevents unnecessary output]' \
'-h[Print help]' \
'--help[Print help]' \
'*::tools -- Tools to fetch, like `node`, `yarn@latest` or `your-package@^14.4.3`:' \
&& ret=0
;;
(install)
_arguments "${_arguments_options[@]}" : \
'--verbose[Enables verbose diagnostics]' \
'--very-verbose[Enables trace-level diagnostics]' \
'(--verbose)--quiet[Prevents unnecessary output]' \
'-h[Print help]' \
'--help[Print help]' \
'*::tools -- Tools to install, like `node`, `yarn@latest` or `your-package@^14.4.3`:' \
&& ret=0
;;
(uninstall)
_arguments "${_arguments_options[@]}" : \
'--verbose[Enables verbose diagnostics]' \
'--very-verbose[Enables trace-level diagnostics]' \
'(--verbose)--quiet[Prevents unnecessary output]' \
'-h[Print help]' \
'--help[Print help]' \
':tool -- The tool to uninstall, like `ember-cli-update`, `typescript`, or <package>:' \
&& ret=0
;;
(pin)
_arguments "${_arguments_options[@]}" : \
'--verbose[Enables verbose diagnostics]' \
'--very-verbose[Enables trace-level diagnostics]' \
'(--verbose)--quiet[Prevents unnecessary output]' \
'-h[Print help]' \
'--help[Print help]' \
'*::tools -- Tools to pin, like `node@lts` or `yarn@^1.14`:' \
&& ret=0
;;
(list)
_arguments "${_arguments_options[@]}" : \
'--format=[Specify the output format]:FORMAT:(human plain)' \
'(-d --default)-c[Show the currently-active tool(s)]' \
'(-d --default)--current[Show the currently-active tool(s)]' \
'(-c --current)-d[Show your default tool(s)]' \
'(-c --current)--default[Show your default tool(s)]' \
'--verbose[Enables verbose diagnostics]' \
'--very-verbose[Enables trace-level diagnostics]' \
'(--verbose)--quiet[Prevents unnecessary output]' \
'-h[Print help (see more with '\''--help'\'')]' \
'--help[Print help (see more with '\''--help'\'')]' \
'::subcommand -- The tool to lookup - `all`, `node`, `npm`, `yarn`, `pnpm`, or the name of a package or binary:' \
&& ret=0
;;
(completions)
_arguments "${_arguments_options[@]}" : \
'-o+[File to write generated completions to]:OUT_FILE:_files' \
'--output=[File to write generated completions to]:OUT_FILE:_files' \
'-f[Write over an existing file, if any]' \
'--force[Write over an existing file, if any]' \
'--verbose[Enables verbose diagnostics]' \
'--very-verbose[Enables trace-level diagnostics]' \
'(--verbose)--quiet[Prevents unnecessary output]' \
'-h[Print help (see more with '\''--help'\'')]' \
'--help[Print help (see more with '\''--help'\'')]' \
':shell -- Shell to generate completions for:(bash elvish fish powershell zsh)' \
&& ret=0
;;
(which)
_arguments "${_arguments_options[@]}" : \
'--verbose[Enables verbose diagnostics]' \
'--very-verbose[Enables trace-level diagnostics]' \
'(--verbose)--quiet[Prevents unnecessary output]' \
'-h[Print help]' \
'--help[Print help]' \
':binary -- The binary to find, e.g. `node` or `npm`:' \
&& ret=0
;;
(use)
_arguments "${_arguments_options[@]}" : \
'--verbose[Enables verbose diagnostics]' \
'--very-verbose[Enables trace-level diagnostics]' \
'(--verbose)--quiet[Prevents unnecessary output]' \
'-h[Print help (see more with '\''--help'\'')]' \
'--help[Print help (see more with '\''--help'\'')]' \
'*::anything:' \
&& ret=0
;;
(setup)
_arguments "${_arguments_options[@]}" : \
'--verbose[Enables verbose diagnostics]' \
'--very-verbose[Enables trace-level diagnostics]' \
'(--verbose)--quiet[Prevents unnecessary output]' \
'-h[Print help]' \
'--help[Print help]' \
&& ret=0
;;
(run)
_arguments "${_arguments_options[@]}" : \
'--node=[Set the custom Node version]:version: ' \
'(--bundled-npm)--npm=[Set the custom npm version]:version: ' \
'(--no-pnpm)--pnpm=[Set the custon pnpm version]:version: ' \
'(--no-yarn)--yarn=[Set the custom Yarn version]:version: ' \
'*--env=[Set an environment variable (can be used multiple times)]:NAME=value: ' \
'(--npm)--bundled-npm[Forces npm to be the version bundled with Node]' \
'(--pnpm)--no-pnpm[Disables pnpm]' \
'(--yarn)--no-yarn[Disables Yarn]' \
'--verbose[Enables verbose diagnostics]' \
'--very-verbose[Enables trace-level diagnostics]' \
'(--verbose)--quiet[Prevents unnecessary output]' \
'-h[Print help]' \
'--help[Print help]' \
'*::command_and_args -- The command to run, along with any arguments:' \
&& ret=0
;;
(help)
_arguments "${_arguments_options[@]}" : \
":: :_volta__help_commands" \
"*::: :->help" \
&& ret=0

    case $state in
    (help)
        words=($line[1] "${words[@]}")
        (( CURRENT += 1 ))
        curcontext="${curcontext%:*:*}:volta-help-command-$line[1]:"
        case $line[1] in
            (fetch)
_arguments "${_arguments_options[@]}" : \
&& ret=0
;;
(install)
_arguments "${_arguments_options[@]}" : \
&& ret=0
;;
(uninstall)
_arguments "${_arguments_options[@]}" : \
&& ret=0
;;
(pin)
_arguments "${_arguments_options[@]}" : \
&& ret=0
;;
(list)
_arguments "${_arguments_options[@]}" : \
&& ret=0
;;
(completions)
_arguments "${_arguments_options[@]}" : \
&& ret=0
;;
(which)
_arguments "${_arguments_options[@]}" : \
&& ret=0
;;
(use)
_arguments "${_arguments_options[@]}" : \
&& ret=0
;;
(setup)
_arguments "${_arguments_options[@]}" : \
&& ret=0
;;
(run)
_arguments "${_arguments_options[@]}" : \
&& ret=0
;;
(help)
_arguments "${_arguments_options[@]}" : \
&& ret=0
;;
        esac
    ;;
esac
;;
        esac
    ;;
esac
}

(( $+functions[_volta_commands] )) ||
_volta_commands() {
    local commands; commands=(
'fetch:Fetches a tool to the local machine' \
'install:Installs a tool in your toolchain' \
'uninstall:Uninstalls a tool from your toolchain' \
'pin:Pins your project'\''s runtime or package manager' \
'list:Displays the current toolchain' \
'completions:Generates Volta completions' \
'which:Locates the actual binary that will be called by Volta' \
'use:' \
'setup:Enables Volta for the current user / shell' \
'run:Run a command with custom Node, npm, pnpm, and/or Yarn versions' \
'help:Print this message or the help of the given subcommand(s)' \
    )
    _describe -t commands 'volta commands' commands "$@"
}
(( $+functions[_volta__completions_commands] )) ||
_volta__completions_commands() {
    local commands; commands=()
    _describe -t commands 'volta completions commands' commands "$@"
}
(( $+functions[_volta__fetch_commands] )) ||
_volta__fetch_commands() {
    local commands; commands=()
    _describe -t commands 'volta fetch commands' commands "$@"
}
(( $+functions[_volta__help_commands] )) ||
_volta__help_commands() {
    local commands; commands=(
'fetch:Fetches a tool to the local machine' \
'install:Installs a tool in your toolchain' \
'uninstall:Uninstalls a tool from your toolchain' \
'pin:Pins your project'\''s runtime or package manager' \
'list:Displays the current toolchain' \
'completions:Generates Volta completions' \
'which:Locates the actual binary that will be called by Volta' \
'use:' \
'setup:Enables Volta for the current user / shell' \
'run:Run a command with custom Node, npm, pnpm, and/or Yarn versions' \
'help:Print this message or the help of the given subcommand(s)' \
    )
    _describe -t commands 'volta help commands' commands "$@"
}
(( $+functions[_volta__help__completions_commands] )) ||
_volta__help__completions_commands() {
    local commands; commands=()
    _describe -t commands 'volta help completions commands' commands "$@"
}
(( $+functions[_volta__help__fetch_commands] )) ||
_volta__help__fetch_commands() {
    local commands; commands=()
    _describe -t commands 'volta help fetch commands' commands "$@"
}
(( $+functions[_volta__help__help_commands] )) ||
_volta__help__help_commands() {
    local commands; commands=()
    _describe -t commands 'volta help help commands' commands "$@"
}
(( $+functions[_volta__help__install_commands] )) ||
_volta__help__install_commands() {
    local commands; commands=()
    _describe -t commands 'volta help install commands' commands "$@"
}
(( $+functions[_volta__help__list_commands] )) ||
_volta__help__list_commands() {
    local commands; commands=()
    _describe -t commands 'volta help list commands' commands "$@"
}
(( $+functions[_volta__help__pin_commands] )) ||
_volta__help__pin_commands() {
    local commands; commands=()
    _describe -t commands 'volta help pin commands' commands "$@"
}
(( $+functions[_volta__help__run_commands] )) ||
_volta__help__run_commands() {
    local commands; commands=()
    _describe -t commands 'volta help run commands' commands "$@"
}
(( $+functions[_volta__help__setup_commands] )) ||
_volta__help__setup_commands() {
    local commands; commands=()
    _describe -t commands 'volta help setup commands' commands "$@"
}
(( $+functions[_volta__help__uninstall_commands] )) ||
_volta__help__uninstall_commands() {
    local commands; commands=()
    _describe -t commands 'volta help uninstall commands' commands "$@"
}
(( $+functions[_volta__help__use_commands] )) ||
_volta__help__use_commands() {
    local commands; commands=()
    _describe -t commands 'volta help use commands' commands "$@"
}
(( $+functions[_volta__help__which_commands] )) ||
_volta__help__which_commands() {
    local commands; commands=()
    _describe -t commands 'volta help which commands' commands "$@"
}
(( $+functions[_volta__install_commands] )) ||
_volta__install_commands() {
    local commands; commands=()
    _describe -t commands 'volta install commands' commands "$@"
}
(( $+functions[_volta__list_commands] )) ||
_volta__list_commands() {
    local commands; commands=()
    _describe -t commands 'volta list commands' commands "$@"
}
(( $+functions[_volta__pin_commands] )) ||
_volta__pin_commands() {
    local commands; commands=()
    _describe -t commands 'volta pin commands' commands "$@"
}
(( $+functions[_volta__run_commands] )) ||
_volta__run_commands() {
    local commands; commands=()
    _describe -t commands 'volta run commands' commands "$@"
}
(( $+functions[_volta__setup_commands] )) ||
_volta__setup_commands() {
    local commands; commands=()
    _describe -t commands 'volta setup commands' commands "$@"
}
(( $+functions[_volta__uninstall_commands] )) ||
_volta__uninstall_commands() {
    local commands; commands=()
    _describe -t commands 'volta uninstall commands' commands "$@"
}
(( $+functions[_volta__use_commands] )) ||
_volta__use_commands() {
    local commands; commands=()
    _describe -t commands 'volta use commands' commands "$@"
}
(( $+functions[_volta__which_commands] )) ||
_volta__which_commands() {
    local commands; commands=()
    _describe -t commands 'volta which commands' commands "$@"
}

if [ "$funcstack[1]" = "_volta" ]; then
    _volta "$@"
else
    compdef _volta volta
fi
