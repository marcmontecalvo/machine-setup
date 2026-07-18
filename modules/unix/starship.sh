#!/usr/bin/env bash
setup_starship() {
  if ! command -v starship >/dev/null; then
    if command -v brew >/dev/null; then brew install starship
    else curl -sS https://starship.rs/install.sh | sh -s -- -y; fi
  fi
  for rc in "$HOME/.bashrc" "$HOME/.zshrc"; do
    touch "$rc"
    grep -q 'starship init' "$rc" || printf '\n# machine-setup: starship\neval "$(starship init %s)"\n' "$(basename "$rc" | sed 's/^\.//;s/rc$//')" >> "$rc"
  done
}
