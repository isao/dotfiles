# shellcheck disable=SC2206,SC2034,SC1091
# SC2206: Intentional word splitting for zsh arrays
# SC2034: Variables like WORDCHARS, SAVEHIST, cdpath are used by zsh itself
# SC1091: Source files may not exist in shellcheck context
whence brew >/dev/null && eval "$(brew shellenv)"

export EDITOR="bbedit -w"
export GREP_COLOR=32 # ANSI/VT100: 32 is green, '1;34' is bold blue
export RSYNC_RSH=ssh

export LESS='--tabs=4 --ignore-case --LONG-PROMPT --RAW-CONTROL-CHARS --no-init --quit-if-one-screen --mouse'

# https://github.com/sharkdp/bat
whence bat >/dev/null && {
    export BAT_STYLE=changes,header,rule,snip
    export BAT_THEME=gruvbox-light
}

# BAUD=38400
# KEYTIMEOUT=60

# default WORDCHARS='*?_-.[]~=/&;!#$%^(){}<>'
WORDCHARS='*?_-.[]~&!#$%^(){}<>'
# ^removes =/;


setopt correct

# Treat `#` as a code comment in an interactive contexts.
setopt interactive_comments

#
#       history

HISTFILE=$HOME/.zsh_history
HISTSIZE=100100 # Set HISTSIZE to a larger number than SAVEHIST to keep a buffer
SAVEHIST=100000 # for history deduplication with option `inc_append_history`.

setopt hist_expire_dups_first
setopt hist_fcntl_lock
setopt hist_find_no_dups
setopt hist_ignore_all_dups # de-duplicate commands in the history entire list
setopt hist_ignore_space
setopt hist_no_functions
setopt hist_no_store
setopt hist_reduce_blanks
setopt hist_save_no_dups
setopt hist_verify
setopt inc_append_history

setopt auto_cd
setopt auto_pushd
setopt pushd_silent
setopt pushd_ignore_dups

# https://robots.thoughtbot.com/cding-to-frequently-used-directories-in-zsh
cdpath=($HOME $HOME/repos)

#
#       history ⬆︎⬇︎

# TODO set-local-history widget?

autoload up-line-or-beginning-search
zle -N up-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search

autoload down-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search

# Edit the current mini-buffer in $EDITOR.
# http://zsh.sourceforge.net/FAQ/zshfaq03.html#l45
autoload -U edit-command-line;
zle -N edit-command-line;
bindkey '^xe' edit-command-line;

# ctrl right/left
bindkey "^[[1;5D" backward-word
bindkey "^[[1;5C" forward-word

# delete to beginning of line
bindkey '^u' backward-kill-line

# two `kill-line` or `backward-kill-line` equals one `kill-buffer`.
bindkey '^k^k' kill-buffer
bindkey '^u^u' kill-buffer

# forward-delete word ahead of the cursor
bindkey "^w" delete-word

# calculator
autoload -Uz zcalc

autoload -Uz colors
colors

# Zsh Reporting
# If nonnegative, commands whose combined user and system execution times
# (measured in seconds) are greater than this value have timing statistics printed
# for them.  Output is suppressed for commands executed within the line editor,
# including completion; commands explicitly marked with the time keyword still
# cause the summary to be printed in this case.
export REPORTTIME=3

if [[ -L ~/.zshrc ]]
then
    myzshd="$HOME/repos/dotfiles/zsh.d"

    source "$myzshd/aliases.zsh"
    source "$myzshd/completions.zsh"
    source "$myzshd/functions.zsh"

    source "$myzshd/bbedit.zsh"
    source "$myzshd/git.zsh"
    source "$myzshd/fzf.zsh"
    source "$myzshd/ripgrep.zsh"
    source "$myzshd/nodejs.zsh"
    source "$myzshd/mcat.zsh"

    source "$myzshd/prompt.zsh"

    [[ -r "$HOME/repos/dotwork/work.zsh" ]] && \
        source "$HOME/repos/dotwork/work.zsh"

    # Must be last. <https://github.com/zsh-users/zsh-syntax-highlighting>
    # "zsh-syntax-highlighting.zsh wraps ZLE widgets. It must be sourced after
    # all custom widgets have been created (i.e., after all zle -N calls and
    # after running compinit). Widgets created later will work, but will not
    # update the syntax highlighting."
    [[ -r "$myzshd/vendor/zsh-syntax-highlighting.zsh" ]] \
        && source "$myzshd/vendor/zsh-syntax-highlighting.zsh"
fi
