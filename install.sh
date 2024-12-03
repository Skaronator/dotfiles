#!/bin/bash
SCRIPT_DIR=$(cd -- "$(dirname -- "$0")" && pwd)

user () {
  printf "\r  [ \033[0;33m??\033[0m ] %s\n" "$1"
}

success () {
  printf "\r\033[2K  [ \033[00;32mOK\033[0m ] %s\n" "$1"
}

# Main function
link_file() {
  local src=$1 dst=$2

  # Create the parent directory if it doesn't exist
  local parent_dir
  parent_dir=$(dirname "$dst")
  if [ ! -d "$parent_dir" ]; then
    mkdir -p "$parent_dir"
    success "created directory $parent_dir"
  fi

  if [ -f "$dst" ] || [ -d "$dst" ] || [ -L "$dst" ]; then
    local currentSrc
    currentSrc="$(readlink "$dst")"

    if [ "$currentSrc" == "$src" ]; then
      success "skipped $src"
      return
    else
      user "File already exists: $dst ($(basename "$src")), what do you want to do?\n\
      [s]kip, [S]kip all, [o]verwrite, [O]verwrite all, [b]ackup, [B]ackup all?"
      read -r -n 1 action

      case "$action" in
        o) overwrite=true;;
        O) overwrite_all=true;;
        b) backup=true;;
        B) backup_all=true;;
        s) skip=true;;
        S) skip_all=true;;
      esac
    fi

    overwrite=${overwrite:-$overwrite_all}
    backup=${backup:-$backup_all}

    if [ "$overwrite" == "true" ]; then
      rm -rf "$dst"
      success "removed $dst"
    fi

    if [ "$backup" == "true" ]; then
      mv "$dst" "${dst}.backup"
      success "moved $dst to ${dst}.backup"
    fi
  fi

  if [ "${skip:-$skip_all}" != "true" ]; then
    ln -s "$src" "$dst"
    success "linked $src to $dst"
  fi
}

if [[ "$(uname)" == "Darwin" ]]; then
    CONFIG_DIR="$HOME/Library/Application Support"
else
    CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"
fi


link_file "$SCRIPT_DIR/git/.gitconfig" "$HOME/.gitconfig"
link_file "$SCRIPT_DIR/git/.fp.gitconfig" "$HOME/.fp.gitconfig"
link_file "$SCRIPT_DIR/git/.gitignore" "$HOME/.gitignore"

link_file "$SCRIPT_DIR/atuin" "$CONFIG_DIR/atuin"
link_file "$SCRIPT_DIR/k9s" "$CONFIG_DIR/k9s"
link_file "$SCRIPT_DIR/zsh-config/.zshrc" "$HOME/.zshrc"
link_file "$SCRIPT_DIR/zsh-config/.p10k.zsh" "$HOME/.p10k.zsh"
