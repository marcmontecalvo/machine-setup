#!/usr/bin/env bash
setup_docker() {
  if [[ "$(uname -s)" == "Darwin" ]]; then
    command -v brew >/dev/null || { echo "Homebrew is required for Docker Desktop on macOS." >&2; return 1; }
    brew install --cask docker
    echo "Start Docker Desktop once to finish initialization."
    return
  fi
  if command -v docker >/dev/null && docker compose version >/dev/null 2>&1; then return; fi
  if command -v apt-get >/dev/null; then
    sudo apt-get update
    sudo apt-get install -y ca-certificates curl
    curl -fsSL https://get.docker.com | sudo sh
  elif command -v dnf >/dev/null; then
    sudo dnf install -y docker docker-compose-plugin
    sudo systemctl enable --now docker
  elif command -v pacman >/dev/null; then
    sudo pacman -Sy --needed --noconfirm docker docker-compose
    sudo systemctl enable --now docker
  else
    echo "Unsupported package manager for automatic Docker installation." >&2; return 1
  fi
  sudo usermod -aG docker "$USER"
  echo "Log out and back in before using Docker without sudo."
}
