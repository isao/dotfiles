volta completions:

    volta completions zsh -f -o "$myzshd/vendor/volta-completions.zsh"

mcat completions:

    mcat --generate=zsh > "$myzshd/vendor/mcat-completions.zsh"

leaf completions <https://leaf.rivolink.mg/docs/features/shell-completion/#script-dump>:

    leaf --auto-complete zsh:dump > "$myzshd/vendor/leaf-completions.zsh"

uv completions:

    uv generate-shell-completion zsh > "$myzshd/vendor/uv-completions.zsh"
