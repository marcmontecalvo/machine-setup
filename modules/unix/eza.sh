#!/usr/bin/env bash
setup_eza() {
  if ! command -v eza >/dev/null; then
    if command -v brew >/dev/null; then brew install eza
    elif command -v apt-get >/dev/null; then sudo apt-get update && sudo apt-get install -y eza
    elif command -v dnf >/dev/null; then sudo dnf install -y eza
    elif command -v pacman >/dev/null; then sudo pacman -Sy --needed --noconfirm eza
    else echo "Install eza manually on this platform." >&2; return 1; fi
  fi
  local block
  block=$(cat <<'EOF'
alias ls='eza --group-directories-first'
alias ll='eza -lah --group-directories-first --git'
alias tree='eza --tree'
EOF
)
  replace_managed_block "$HOME/.bashrc" "eza" "$block"
  replace_managed_block "$HOME/.zshrc" "eza" "$block"
}
