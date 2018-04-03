#
#       completion

autoload -Uz compinit
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

#
# gulp-autocompletion-zsh
# https://github.com/robbyrussell/oh-my-zsh/blob/master/plugins/gulp/gulp.plugin.zsh
# Autocompletion for your gulp.js tasks
#
# Copyright(c) 2014 André König <andre.koenig@posteo.de>
# MIT Licensed
# André König
# Github: https://github.com/akoenig
# Twitter: https://twitter.com/caiifr
#
# Grabs all available tasks from the `gulpfile.js`
# in the current directory.
#
function $$gulp_completion {
    compls=$(gulp --tasks-simple 2>/dev/null)
    completions=(${=compls})
    compadd -- $completions
}

compdef $$gulp_completion gulp
