#!/usr/bin/env bash
setup_direnv() {
  if ! command -v direnv >/dev/null; then
    if command -v brew >/dev/null; then brew install direnv
    elif command -v apt-get >/dev/null; then sudo apt-get update && sudo apt-get install -y direnv
    elif command -v dnf >/dev/null; then sudo dnf install -y direnv
    elif command -v pacman >/dev/null; then sudo pacman -Sy --needed --noconfirm direnv
    else echo "Unsupported package manager." >&2; return 1; fi
  fi
  grep -q 'direnv hook bash' "$HOME/.bashrc" 2>/dev/null || printf '\n# machine-setup: direnv\neval "$(direnv hook bash)"\n' >> "$HOME/.bashrc"
  grep -q 'direnv hook zsh' "$HOME/.zshrc" 2>/dev/null || printf '\n# machine-setup: direnv\neval "$(direnv hook zsh)"\n' >> "$HOME/.zshrc"
}
