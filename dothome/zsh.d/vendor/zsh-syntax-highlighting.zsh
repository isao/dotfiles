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
