export EDITOR=$(/usr/bin/which bbedit..sh bbedit nano vim vi 2>/dev/null | grep ^/ | head -1)
export GREP_COLOR=32 # ANSI/VT100: 32 is green, '1;34' is bold blue
export RSYNC_RSH=ssh

export LESS='--tabs=4 -iFMRX'
type highlight >/dev/null && \
    export LESSOPEN="| highlight %s --out-format xterm256 --quiet --force --style fine_blue"

# BAUD=38400
# default WORDCHARS='*?_-.[]~=/&;!#$%^(){}<>'
WORDCHARS='*?_-.[]~&!#$%^(){}<>'
#KEYTIMEOUT=60


#
#       history

HISTFILE=$HOME/.zsh_history
HISTSIZE=1000
SAVEHIST=900

setopt hist_ignore_dups # ignore duplication command history list
setopt hist_expire_dups_first
setopt hist_find_no_dups
setopt hist_ignore_space
setopt hist_no_functions
setopt hist_no_store
setopt hist_reduce_blanks

setopt append_history
setopt extended_history
setopt inc_append_history
setopt share_history


# http://chneukirchen.org/blog/archive/2012/02/10-new-zsh-tricks-you-may-not-know.html
# http://zsh.sourceforge.net/Intro/intro_6.html
# DIRSTACKSIZE=16
# DIRSTACKFILE=~/.zdirs
# if [[ -f $DIRSTACKFILE ]] && [[ $#dirstack -eq 0 ]]
# then
#     dirstack=(${(f)"$(< $DIRSTACKFILE)"})
#     [[ -d $dirstack[1] ]] && cd $dirstack[1] && cd $OLDPWD
# fi
# chpwd() {
#     print -l $PWD ${(u)dirstack} >$DIRSTACKFILE
# }

setopt auto_cd
setopt autopushd
setopt pushdminus
setopt pushdsilent
setopt pushdtohome
setopt pushd_ignore_dups


#
#       history ⬆︎⬇︎

# TODO set-local-history widget?

autoload up-line-or-beginning-search
autoload down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
# bindkey "^[[A" history-beginning-search-backward
# bindkey "^[[B" history-beginning-search-forward
bindkey "^[[A" up-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search

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
    dotfiles=$(dirname $(readlink ~/.zshrc))
    source "$dotfiles/zsh.d/aliases.zsh"
    source "$dotfiles/zsh.d/completions.zsh"
    source "$dotfiles/zsh.d/functions.zsh"
    source "$dotfiles/zsh.d/prompt.zsh"

    source "$dotfiles/zsh.d/bbedit.zsh"
    source "$dotfiles/zsh.d/fzf.zsh"
    [[ -r "$dotfiles/zsh.d/work.zsh" ]] && source "$dotfiles/zsh.d/work.zsh"
fi
