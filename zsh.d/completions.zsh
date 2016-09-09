#
#       completion

autoload -U compinit
compinit

# When completing from the middle of a word, move the cursor to the end of the word
setopt always_to_end

setopt menu_complete
setopt list_packed
setopt auto_param_slash
setopt auto_remove_slash

# Allow lower-case characters to match upper case ones.
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# Git: only complete local files
# http://stackoverflow.com/questions/9810327
# http://www.zsh.org/mla/workers/2011/msg00490.html
# __git_files () {
#     _wanted files expl 'local files' _files
# }

# Install homebrew completions
# ln -s "$(brew --prefix)/Library/Contributions/brew_zsh_completion.zsh" /usr/local/share/zsh/site-functions/_brew

if [[ -r /usr/local/etc/bash_completion.d/cdargs-bash.sh ]]
then
    source /usr/local/etc/bash_completion.d/cdargs-bash.sh
fi

# brew home zsh-syntax-highlighting
if [[ -r /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]
then
    source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)
fi

if [[ -e /usr/local/etc/bash_completion.d/tig-completion.bash ]]
then
    source /usr/local/etc/bash_completion.d/tig-completion.bash
fi
