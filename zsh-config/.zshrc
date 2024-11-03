autoload -Uz compinit bashcompinit
compinit
bashcompinit

export DOTFILES_DIR=$(dirname -- "$(dirname -- "$(readlink -f -- "$HOME/.zshrc")")")

files=($(find -L "$DOTFILES_DIR/zsh-scripts" -type f -print))

for file in "${files[@]}"; do
  source "$file"
done

if [ "$TERM_PROGRAM" != "Apple_Terminal" ]; then
  command -v oh-my-posh >/dev/null 2>&1 && eval "$(oh-my-posh init zsh)"
fi

# # Load necessary widgets
# autoload -Uz up-line-or-beginning-search
# autoload -Uz down-line-or-beginning-search

# Bind the widgets to the up and down arrow keys
# bindkey "^[[A" up-line-or-beginning-search
# bindkey "^[[B" down-line-or-beginning-search

bindkey "^[[1;3C" forward-word
bindkey "^[[1;3D" backward-word
