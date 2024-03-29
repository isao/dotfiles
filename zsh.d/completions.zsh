# man zshcompsys

# Enable Homebrew completions (brew, fd, git, rg, tig). Note! fpath must be set
# before compinit, and homebrew's path must be first.
[[ -d "$HOMEBREW_PREFIX/share/zsh/site-functions" ]] && \
    fpath=("$HOMEBREW_PREFIX/share/zsh/site-functions" $fpath)

#
#       completion

autoload -Uz compinit
compinit

setopt list_packed

# https://github.com/zanshin/dotfiles/blob/master/zsh/setopt.zsh
setopt always_to_end # When completing from the middle of a word, move the cursor to the end of the word
setopt auto_menu # show completion menu on successive tab press. needs unsetop menu_complete to work
#unsetopt menu_complete # do not autoselect the first completion entry
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

# http://zsh.sourceforge.net/FAQ/zshfaq04.html#l52
# To try filename completion when other completions fail:
zstyle ':completion:*' completer _complete _ignored _files

# Complete from middle of a word, using just what's up to the cursor.
# http://zsh.sourceforge.net/FAQ/zshfaq04.html#l50
# Defualt is `bindkey '^I' expand-or-complete`
bindkey '^I' expand-or-complete-prefix

# Automatically escape shell characters when pasting URLs.
autoload -U url-quote-magic
zle -N self-insert url-quote-magic


#
#   Other completions
#

for i in shellcheck tsc ctags
do
    whence "$i" >/dev/null && compdef _gnu_generic "$i"
done

# gulp-autocompletion-zsh
# https://github.com/robbyrussell/oh-my-zsh/blob/master/plugins/gulp/gulp.plugin.zsh
# Autocompletion for your gulp.js tasks
# Copyright(c) 2014 André König <andre.koenig@posteo.de> MIT Licensed André König
if (whence gulp >/dev/null) {
    function $$gulp_completion {
        compls=$(gulp --tasks-simple 2>/dev/null)
        completions=(${=compls})
        compadd -- $completions
    }
    compdef $$gulp_completion gulp
}

if (whence defaultbrowser >/dev/null) {
    function _defaultbrowser {
        compls=$(defaultbrowser | cut -c 3- | xargs)
        completions=(${=compls})
        compadd -- $completions
    }
    compdef _defaultbrowser defaultbrowser
}
