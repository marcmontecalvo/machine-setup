#!/usr/bin/env bash

setup_shell() {
  local rc_file="$HOME/.bashrc"
  [[ "${SHELL:-}" == *zsh ]] && rc_file="$HOME/.zshrc"

  local start='# >>> machine-setup shell >>>'
  local end='# <<< machine-setup shell <<<'
  local tmp
  tmp="$(mktemp)"

  if [[ -f "$rc_file" ]]; then
    awk -v start="$start" -v end="$end" '
      $0 == start {skip=1; next}
      $0 == end {skip=0; next}
      !skip {print}
    ' "$rc_file" > "$tmp"
  fi

  cat >> "$tmp" <<'EOF'
# >>> machine-setup shell >>>
export HISTCONTROL=ignoreboth:erasedups
export HISTSIZE=50000
export HISTFILESIZE=100000
shopt -s histappend 2>/dev/null || true
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias grep='grep --color=auto'
alias ..='cd ..'
alias ...='cd ../..'
alias gs='git status --short --branch'
alias gl='git log --oneline --decorate --graph --all'
# <<< machine-setup shell <<<
EOF

  mv "$tmp" "$rc_file"
}
