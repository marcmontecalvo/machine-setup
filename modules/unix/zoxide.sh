#!/usr/bin/env bash
setup_zoxide() {
  if ! command -v zoxide >/dev/null; then
    if command -v brew >/dev/null; then brew install zoxide
    elif command -v apt-get >/dev/null; then sudo apt-get update && sudo apt-get install -y zoxide
    elif command -v dnf >/dev/null; then sudo dnf install -y zoxide
    elif command -v pacman >/dev/null; then sudo pacman -Sy --needed --noconfirm zoxide
    else curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh; fi
  fi
  replace_managed_block "$HOME/.bashrc" "zoxide" 'eval "$(zoxide init bash)"'
  replace_managed_block "$HOME/.zshrc" "zoxide" 'eval "$(zoxide init zsh)"'
}
