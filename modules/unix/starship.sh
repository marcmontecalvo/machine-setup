#!/usr/bin/env bash
setup_starship() {
  if ! command -v starship >/dev/null; then
    if command -v brew >/dev/null; then brew install starship
    else curl -sS https://starship.rs/install.sh | sh -s -- -y; fi
  fi
  replace_managed_block "$HOME/.bashrc" "starship" 'eval "$(starship init bash)"'
  replace_managed_block "$HOME/.zshrc" "starship" 'eval "$(starship init zsh)"'
}
