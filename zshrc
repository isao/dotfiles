export EDITOR=$(/usr/bin/which bbedit..sh bbedit nano vim vi 2>/dev/null | grep ^/ | head -1)
export LESS='--tabs=2 -iFMRX'
export GREP_COLOR=32 # ANSI/VT100: 32 is green, '1;34' is bold blue
export RSYNC_RSH=ssh

BAUD=38400
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
autoload -Uzz zcalc

autoload -Uz colors
colors


#
#       vcs_info

autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' check-for-changes true

# %a action
# %b branch
#    %26<…<%b truncate the branchname to 26 characters
# %c staged changes - format with stagedstr
# %m stash info
# %r repo root dirname
# %S path relative to root
# %u unstaged changes - format with unstagedstr

zstyle ':vcs_info:git:*' actionformats "%{$fg_bold[blue]%}(%a)"
zstyle ':vcs_info:git:*' unstagedstr "%{$fg_no_bold[red]%}±"
zstyle ':vcs_info:git:*' stagedstr "%{$fg_bold[green]%}±"
zstyle ':vcs_info:git:*' formats "%{$fg_no_bold[blue]%}%32<…<%b%a%{$reset_color%}%u%c%m%{$reset_color%}"
#zstyle ':vcs_info:*+*:*' debug true

zstyle ':vcs_info:git*+set-message:*' hooks git-misc
+vi-git-misc() {
    local untracked stashes

    # show untracked file count like ?2 where number is file count
    untracked=$(echo $(git ls-files -o --exclude-standard | wc -l))
    if [[ $untracked -gt 0 ]]
    then
        hook_com[misc]+="%{$fg_no_bold[white]%}?$untracked"
    fi

    # show stash count like s3 where number is stash count
    stashes=$(echo $(git stash list | wc -l))
    if [[ $stashes -gt 0 ]]
    then
        hook_com[misc]+="%{$fg_no_bold[white]%}$stashes"
    fi
}

# 1 is tab title - cwd
# 2 is window title - user@host, then terminal will show process & args
precmd_title_info() {
    print -Pn "\e]1;%~\a"
    print -Pn "\e]2;%n@%m\a"
}
precmd_functions+=(vcs_info precmd_title_info)

#
#       prompt

setopt prompt_subst
setopt transient_rprompt

# Show red "err:num" for the last exit code if it was non-zero.
# %(?,'', %{$fg_bold[red]%}err:%?%{$reset_color%})
# http://www.lowlevelmanager.com/2012/03/smile-zsh-prompt-happysad-face.html

# from the 256 color palette
# print -P '%F{246}gray%f'

RPROMPT=\$vcs_info_msg_0_%(?,'', %{$fg_bold[red]%}err:%?%{$reset_color%})
PROMPT="%{%F{246}%}%T•%{%f$reset_color%}%2~%# "

# Refresh the prompt, including vcs_info, every 60 seconds.
# http://www.zsh.org/mla/users/2007/msg00944.html
# TMOUT=60
# TRAPALRM() {
#     vcs_info
#     zle reset-prompt
# }

# Refresh the prompt (not vcs_info) before command line instructions are run.
# http://stackoverflow.com/questions/13125825
function _reset-prompt-and-accept-line {
    zle reset-prompt
    zle .accept-line     # Note the . meaning the built-in accept-line.
}
zle -N accept-line _reset-prompt-and-accept-line

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

    source "$dotfiles/zsh.d/bbedit.zsh"
    source "$dotfiles/zsh.d/fzf.zsh"
    [[ -r "$dotfiles/zsh.d/work.zsh" ]] && source "$dotfiles/zsh.d/work.zsh"
fi
