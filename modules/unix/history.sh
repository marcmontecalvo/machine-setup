#!/usr/bin/env bash

setup_history() {
  local inputrc="$HOME/.inputrc"
  local start='# >>> machine-setup history >>>'
  local end='# <<< machine-setup history <<<'
  local tmp
  tmp="$(mktemp)"

  if [[ -f "$inputrc" ]]; then
    awk -v start="$start" -v end="$end" '
      $0 == start {skip=1; next}
      $0 == end {skip=0; next}
      !skip {print}
    ' "$inputrc" > "$tmp"
  fi

  cat >> "$tmp" <<'EOF'
# >>> machine-setup history >>>
"\e[A": history-search-backward
"\e[B": history-search-forward
set completion-ignore-case on
set show-all-if-ambiguous on
set colored-stats on
# <<< machine-setup history <<<
EOF

  mv "$tmp" "$inputrc"
  bind -f "$inputrc" 2>/dev/null || true
}
