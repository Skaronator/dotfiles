#!/bin/bash
SCRIPT_DIR=$(cd -- "$(dirname -- "$0")" && pwd)

user () {
  printf "\r  [ \033[0;33m??\033[0m ] $1\n"
}

success () {
  printf "\r\033[2K  [ \033[00;32mOK\033[0m ] $1\n"
}

# Main function
link_file() {
  local src=$1 dst=$2

  if [ -f "$dst" ] || [ -d "$dst" ] || [ -L "$dst" ]; then
    local currentSrc="$(readlink "$dst")"

    if [ "$currentSrc" == "$src" ]; then
      success "skipped $src"
      return
    else
      user "File already exists: $dst ($(basename "$src")), what do you want to do?\n\
      [s]kip, [S]kip all, [o]verwrite, [O]verwrite all, [b]ackup, [B]ackup all?"
      read -n 1 action

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
    ln -s "$1" "$2"
    success "linked $1 to $2"
  fi
}


link_file "$SCRIPT_DIR/git/.gitconfig" "$HOME/.gitconfig"
link_file "$SCRIPT_DIR/git/.fiantix.gitconfig" "$HOME/.fiantix.gitconfig"
link_file "$SCRIPT_DIR/git/.gitignore" "$HOME/.gitignore"

link_file "$SCRIPT_DIR/atuin" "$HOME/.config/atuin"
link_file "$SCRIPT_DIR/zsh/.zshrc" "$HOME/.zshrc"
