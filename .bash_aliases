#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# functions
install_krew_plugins() {
  if command -v kubectl &> /dev/null && kubectl krew version &> /dev/null; then
    kubectl krew update
    kubectl krew install rook-ceph
    kubectl krew install oidc-login
    kubectl krew install cnpg
    return 0
  fi
}

# Alias
alias t='terraform'
alias k='kubectl'
alias d='docker'
alias dc='docker compose'

# Homebrew
export HOMEBREW_NO_ENV_HINTS="false"
alias brewfile='(cd "$SCRIPT_DIR" && brew bundle install && install_krew_plugins)'

# Paths
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"


