#compdef mcat

autoload -U is-at-least

_mcat() {
    typeset -A opt_args
    typeset -a _arguments_options
    local ret=1

    if is-at-least 5.2; then
        _arguments_options=(-s -S -C)
    else
        _arguments_options=(-s -C)
    fi

    local context curcontext="$curcontext" state line
    _arguments "${_arguments_options[@]}" : \
'-o+[Output format]:type:(html md image video inline interactive)' \
'--output=[Output format]:type:(html md image video inline interactive)' \
'-t+[Color theme \[default\: github\]]: :(catppuccin nord monokai dracula gruvbox one_dark solarized tokyo_night makurai_light makurai_dark ayu ayu_mirage github synthwave material rose_pine kanagawa vscode everforest autumn spring)' \
'--theme=[Color theme \[default\: github\]]: :(catppuccin nord monokai dracula gruvbox one_dark solarized tokyo_night makurai_light makurai_dark ayu ayu_mirage github synthwave material rose_pine kanagawa vscode everforest autumn spring)' \
'--md-image=[what images to render in the markdown \[default\: auto\]]:mode:(all small none auto)' \
'--color=[Control ANSI formatting \[default\: auto\]]:mode:(never always auto)' \
'--pager=[Modify the default pager \[default\: '\''less -r'\''\]]:command:_default' \
'--paging=[Control paging behavior \[default\: auto\]]:mode:(never always auto)' \
'--opts=[Options for --output inline\: *  center=<bool> *  inline=<bool> *  width=<string> *  height=<string> *  scale=<f32> *  spx=<string> *  sc=<string> *  zoom=<usize> *  x=<int> *  y=<int> Example\: --opts '\''center=false,inline=true,width=80%,height=20c,scale=0.5,spx=1920x1080,sc=100x20xforce,zoom=2,x=16,y=8'\'']: :_default' \
'--ls-opts=[Options for directory listings\: *  x_padding=<string> *  y_padding=<string> *  min_width=<string> *  max_width=<string> *  height=<string> *  items_per_row=<usize> Example\: --ls-opts '\''x_padding=4c,y_padding=2c,min_width=4c,max_width=16c,height=8%,items_per_row=12'\'']: :_default' \
'--generate=[Generate shell completions]:shell:(bash zsh fish powershell)' \
'--no-linenumbers[Disable line numbers in code blocks]' \
'-f[sets md-image to none, for speed.]' \
'-C[Shortcut for --color never]' \
'-c[Shortcut for --color always]' \
'-P[Shortcut for --paging never]' \
'-p[Shortcut for --paging always]' \
'-i[Shortcut for --output inline]' \
'-s[Add style to HTML output (when HTML is the output)]' \
'--style-html[Add style to HTML output (when HTML is the output)]' \
'--report[Reports image/video dimensions and additional info]' \
'--silent[Removes loading bars]' \
'--kitty[Use Kitty image protocol]' \
'--iterm[Use iTerm2 image protocol]' \
'--sixel[Use Sixel image protocol]' \
'--ascii[Use ASCII art output]' \
'--hori[Concatenate images horizontally]' \
'--delete-images[Delete all images (Kitty only)]' \
'-a[Include hidden files]' \
'--hidden[Include hidden files]' \
'--fetch-chromium[Download and prepare chromium]' \
'--fetch-ffmpeg[Download and prepare ffmpeg]' \
'--fetch-clean[Clean up local binaries]' \
'-h[Print help]' \
'--help[Print help]' \
'-V[Print version]' \
'--version[Print version]' \
'*::input -- Input source (file/dir/url/ls):_default' \
&& ret=0
}

(( $+functions[_mcat_commands] )) ||
_mcat_commands() {
    local commands; commands=()
    _describe -t commands 'mcat commands' commands "$@"
}

if [ "$funcstack[1]" = "_mcat" ]; then
    _mcat "$@"
else
    compdef _mcat mcat
fi
