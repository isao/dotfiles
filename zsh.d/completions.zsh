# man zshcompsys

#
#       completion

autoload -Uz compinit
compinit

# When completing from the middle of a word, move the cursor to the end of the word
# setopt always_to_end

# On an ambiguous completion, instead of listing possibilities or beeping, insert
# the first match immediately.  Then when completion is requested again, remove
# the first match and insert the second match, etc.  When there are no more
# matches, go back to the first one again.  reverse-menu-complete may be used  to
# loop through the list in the other direction. This option overrides AUTO_MENU.
setopt menu_complete

# setopt list_packed

# https://github.com/zanshin/dotfiles/blob/master/zsh/setopt.zsh
setopt always_to_end # When completing from the middle of a word, move the cursor to the end of the word    
# setopt auto_menu # show completion menu on successive tab press. needs unsetop menu_complete to work
# unsetopt menu_complete # do not autoselect the first completion entry
setopt auto_name_dirs # any parameter that is set to the absolute name of a directory immediately becomes a name for that directory
setopt complete_in_word # Allow completion from within a word/phrase

setopt numeric_glob_sort

# This way you tell zsh comp to take the first part of the path to be
# exact, and to avoid partial globs. Now path completions became nearly
# immediate.
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh_completion_cache

# Allow lower-case characters to match upper case ones.
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# zsh-lovers: cd will never select the parent directory (e.g.: cd ../<TAB>):
zstyle ':completion:*:cd:*' ignore-parents parent pwd
# remove slash if argument is a directory
zstyle ':completion:*' squeeze-slashes true

type shellcheck >/dev/null && \
    compdef _gnu_generic shellcheck

type tsc >/dev/null && \
    compdef _gnu_generic tsc

# brew home zsh-syntax-highlighting
if [[ -r /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]
then
    source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)
fi


# gulp-autocompletion-zsh
# https://github.com/robbyrussell/oh-my-zsh/blob/master/plugins/gulp/gulp.plugin.zsh
# Autocompletion for your gulp.js tasks
# Copyright(c) 2014 André König <andre.koenig@posteo.de> MIT Licensed André König
function $$gulp_completion {
    compls=$(gulp --tasks-simple 2>/dev/null)
    completions=(${=compls})
    compadd -- $completions
}

compdef $$gulp_completion gulp
