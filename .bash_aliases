#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Alias
alias t='terraform'
alias k='kubectl'
alias d='docker'
alias dc='docker compose'

# Homebrew
install_krew_plugins() {
  if command -v kubectl &> /dev/null && kubectl krew version &> /dev/null; then
    kubectl krew update
    kubectl krew install rook-ceph
    kubectl krew install oidc-login
    kubectl krew install cnpg
    return 0
  fi
}
export HOMEBREW_NO_ENV_HINTS="false"
alias brewfile='(cd "$SCRIPT_DIR" && brew bundle install && install_krew_plugins)'

# Kubernetes
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
export KUBE_EDITOR=nano
# Disable k0s telemetry
export DISABLE_TELEMETRY=true

# dotfiles rewrite
export GIT_CONFIG="$SCRIPT_DIR/.gitconfig.global"

# Setup Tools and autocompletion
if ! shopt -oq posix; then
  if [ -f "/usr/share/bash-completion/bash_completion" ]; then
    source "/usr/share/bash-completion/bash_completion"
  elif [ -f "/etc/bash_completion" ]; then
    source "/etc/bash_completion"
  fi
fi

command -v brew >/dev/null 2>&1 && eval "$(brew shellenv)"
command -v atuin >/dev/null 2>&1 && eval "$(atuin init bash)"

command -v helm >/dev/null 2>&1 && eval "$(helm completion bash)"

command -v docker >/dev/null 2>&1 && eval "$(docker completion bash)"
command -v docker >/dev/null 2>&1 && complete -F __start_docker d

command -v kubectl >/dev/null 2>&1 && eval "$(kubectl completion bash)"
command -v kubectl >/dev/null 2>&1 && complete -F __start_kubectl k

command -v terraform >/dev/null 2>&1 && complete -C "$(which terraform)" terraform
command -v terraform >/dev/null 2>&1 && complete -C "$(which terraform)" t
