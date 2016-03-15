export EDITOR=$(which bbedit..sh bbedit nano vim vi |grep ^/ |head -1)
export LESS='--tabs=2 -iFMRX'
export GREP_COLOR=32 # ANSI/VT100: 32 is green, '1;34' is bold blue
export RSYNC_RSH=ssh

BAUD=38400
# default WORDCHARS='*?_-.[]~=/&;!#$%^(){}<>'
WORDCHARS='*?_-.[]~&!#$%^(){}<>'

#
#       history

HISTFILE=$HOME/.zsh_history
HISTSIZE=10000
SAVEHIST=9000

#setopt hist_ignore_dups # ignore duplication command history list
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
DIRSTACKSIZE=16
DIRSTACKFILE=~/.zdirs
if [[ -f $DIRSTACKFILE ]] && [[ $#dirstack -eq 0 ]]
then
    dirstack=(${(f)"$(< $DIRSTACKFILE)"})
    [[ -d $dirstack[1] ]] && cd $dirstack[1] && cd $OLDPWD
fi
chpwd() {
    print -l $PWD ${(u)dirstack} >$DIRSTACKFILE
}

setopt auto_cd
setopt autopushd
setopt pushdminus
setopt pushdsilent
setopt pushdtohome
setopt pushd_ignore_dups


#
#       history ⬆︎⬇︎

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


#
#       completion

autoload -U compinit
compinit

# When completing from the middle of a word, move the cursor to the end of the word
setopt always_to_end

setopt MENU_COMPLETE
setopt LIST_PACKED
setopt AUTO_PARAM_SLASH
setopt AUTO_REMOVE_SLASH

# Allow lower-case characters to match upper case ones.
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'


# zman colors
autoload -U colors
colors


#
#       git/vcs

autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' check-for-changes true

# %a action
# %b branch
#    %26<…<%b truncate the branchname to 26 characters
# %c staged changes - string used per stagedstr
# %m stash info
# %r repo root dirname
# %S path relative to root
# %u unstaged changes - string used per unstagedstr

zstyle ':vcs_info:*' actionformats "%{$fg_bold[blue]%}(%a)"
zstyle ':vcs_info:*' unstagedstr "%{$fg_bold[red]%}±"
zstyle ':vcs_info:*' stagedstr "%{$fg_bold[green]%}±"
zstyle ':vcs_info:*' formats "%u%c%m%{$fg_no_bold[blue]%}%22<…<%b%a%{$reset_color%}"

zstyle ':vcs_info:git*+set-message:*' hooks git-misc
+vi-git-misc() {
    local untracked stashes

    # show untracked file count
    untracked=$(echo $(git ls-files -o --exclude-standard | wc -l))
    if [[ $untracked -gt 0 ]]
    then
        hook_com[misc]+="%{$fg_no_bold[white]%}?$untracked"
    fi

    # show stash count
    stashes=$(echo $(git stash list | wc -l))
    if [[ $stashes -gt 0 ]]
    then
        hook_com[misc]+="%{$fg_no_bold[cyan]%}s$stashes"
    fi
}

precmd_vcs_info() {
    vcs_info
}
precmd_functions+=( precmd_vcs_info )

#
#       prompt

setopt prompt_subst
setopt transient_rprompt

# Show red "err:num" is last exit code was non-zero
# %(?,'', %{$fg_bold[red]%}err:%?%{$reset_color%})
# http://www.lowlevelmanager.com/2012/03/smile-zsh-prompt-happysad-face.html
RPROMPT='$vcs_info_msg_0_'%(?,'', %{$fg_bold[red]%}err:%?%{$reset_color%})
PROMPT="%{$fg_bold[white]%}%T•%{$reset_color%}%2~%# "


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
    source "$dotfiles/zsh.d/functions.zsh"
    source "$dotfiles/zsh.d/fzf.zsh"
    source "$dotfiles/zsh.d/work.zsh"
fi

# Install homebrew completions
# ln -s "$(brew --prefix)/Library/Contributions/brew_zsh_completion.zsh" /usr/local/share/zsh/site-functions/_brew

if [[ -x /usr/local/bin/cdargs ]]
then
    source "$(brew ls -v cdargs | grep contrib/cdargs-bash.sh)"
fi

if [[ -r /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]
then
    source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)
fi
