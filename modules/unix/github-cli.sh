#!/usr/bin/env bash
setup_github_cli() {
  if ! command -v gh >/dev/null; then
    if command -v brew >/dev/null; then brew install gh
    elif command -v apt-get >/dev/null; then sudo apt-get update && sudo apt-get install -y gh
    elif command -v dnf >/dev/null; then sudo dnf install -y gh
    elif command -v pacman >/dev/null; then sudo pacman -Sy --needed --noconfirm github-cli
    else echo "Unsupported package manager." >&2; return 1; fi
  fi
  gh auth status >/dev/null 2>&1 || gh auth login --web --git-protocol ssh
}
