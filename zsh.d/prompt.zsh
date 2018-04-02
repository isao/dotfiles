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
