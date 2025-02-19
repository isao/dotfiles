# Note `/opt/brew/bin` is added to `/etc/paths` to ensure it comes before the
# defaults. Paths that can come last can be added to `~/.zshenv`.
# <https://unix.stackexchange.com/a/250456> If `/etc/paths` isn't modified, add
# Homebrew to beginning of path (so we can use latest git, etc).
#grep -q /opt/brew/bin /etc/paths || path=(/opt/brew/bin $path)
# Added to `/etc/paths`:
#   /opt/brew/bin             <- added
#   /usr/local/bin
#   /usr/bin
#   /bin
#   /usr/sbin
#   /sbin
#   ./node_modules/.bin       <- added
#   /Users/isao/.volta/bin    <- added

whence brew >/dev/null && export HOMEBREW_PREFIX="${$(brew --prefix):-/usr/local}"

export EDITOR=$(where bbedit..sh bbedit code nano vim vi | grep ^/ | head -1)
export GREP_COLOR=32 # ANSI/VT100: 32 is green, '1;34' is bold blue
export RSYNC_RSH=ssh

export LESS='--tabs=4 --ignore-case --LONG-PROMPT --RAW-CONTROL-CHARS --no-init --quit-if-one-screen'

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

#
#       history

HISTFILE=$HOME/.zsh_history
HISTSIZE=100100
SAVEHIST=100000
# ^Set SAVEHIST less than HISTSIZE, as a buffer for history deduplication.

setopt hist_expire_dups_first
setopt hist_fcntl_lock
setopt hist_find_no_dups
setopt hist_ignore_dups # ignore duplication command history list
setopt hist_ignore_space
setopt hist_no_functions
setopt hist_no_store
setopt hist_reduce_blanks
setopt hist_save_no_dups

setopt append_history
setopt extended_history
setopt inc_append_history
setopt share_history

setopt auto_cd
setopt autopushd
setopt pushdminus
setopt pushdsilent
setopt pushdtohome
setopt pushd_ignore_dups

# https://robots.thoughtbot.com/cding-to-frequently-used-directories-in-zsh
cdpath=($HOME $HOME/repos)

# Save and restore dirstack.
# http://chneukirchen.org/blog/archive/2012/02/10-new-zsh-tricks-you-may-not-know.html
# http://zsh.sourceforge.net/Intro/intro_6.html
DIRSTACKFILE=~/.zdirs
DIRSTACKSIZE=66
if [[ -f $DIRSTACKFILE ]] && [[ $#dirstack -eq 0 ]]
then
    dirstack=(${(f)"$(< $DIRSTACKFILE)"})
fi
chpwd() {
    print -l $PWD ${(u)dirstack} >$DIRSTACKFILE
}

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

export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"

# Zsh Reporting
# If nonnegative, commands whose combined user and system execution times
# (measured in seconds) are greater than this value have timing statistics printed
# for them.  Output is suppressed for commands executed within the line editor,
# including completion; commands explicitly marked with the time keyword still
# cause the summary to be printed in this case.
export REPORTTIME=3

if [[ -L ~/.zshrc ]]
then
    local dotfiles=$(dirname $(readlink ~/.zshrc))

    source "$dotfiles/zsh.d/aliases.zsh"
    source "$dotfiles/zsh.d/completions.zsh"
    source "$dotfiles/zsh.d/functions.zsh"

    source "$dotfiles/zsh.d/bbedit.zsh"
    source "$dotfiles/zsh.d/git.zsh"
    source "$dotfiles/zsh.d/fzf.zsh"
    source "$dotfiles/zsh.d/nodejs.zsh"

    source "$dotfiles/zsh.d/prompt.zsh"

    [[ -r "$dotfiles/zsh.d/work.zsh" ]] && source "$dotfiles/zsh.d/work.zsh"
fi

# Must be last in .zshrc <https://github.com/zsh-users/zsh-syntax-highlighting>
# "zsh-syntax-highlighting.zsh wraps ZLE widgets. It must be sourced after all
# custom widgets have been created (i.e., after all zle -N calls and after
# running compinit). Widgets created later will work, but will not update the
# syntax highlighting."
if [[ -r "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]
then
    source "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
    ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)
fi
