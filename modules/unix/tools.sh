#!/usr/bin/env bash

setup_tools() {
  local packages=(curl jq ripgrep fd-find fzf bat tree tmux htop)

  if command -v apt-get >/dev/null 2>&1; then
    sudo apt-get update
    sudo apt-get install -y "${packages[@]}"
  elif command -v dnf >/dev/null 2>&1; then
    sudo dnf install -y curl jq ripgrep fd-find fzf bat tree tmux htop
  elif command -v pacman >/dev/null 2>&1; then
    sudo pacman -Sy --needed --noconfirm curl jq ripgrep fd fzf bat tree tmux htop
  elif command -v brew >/dev/null 2>&1; then
    brew install curl jq ripgrep fd fzf bat tree tmux htop
  else
    echo "No supported package manager found; skipping CLI tools." >&2
  fi
}
