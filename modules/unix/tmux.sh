#!/usr/bin/env bash
setup_tmux() {
  if ! command -v tmux >/dev/null; then
    if command -v brew >/dev/null; then brew install tmux
    elif command -v apt-get >/dev/null; then sudo apt-get update && sudo apt-get install -y tmux
    elif command -v dnf >/dev/null; then sudo dnf install -y tmux
    elif command -v pacman >/dev/null; then sudo pacman -Sy --needed --noconfirm tmux
    else echo "Unsupported package manager." >&2; return 1; fi
  fi

  local block
  block=$(cat <<'EOF'
set -g mouse on
set -g history-limit 100000
set -g base-index 1
setw -g pane-base-index 1
set -g renumber-windows on
set -g escape-time 10
set -g status-interval 5
setw -g mode-keys vi
bind r source-file ~/.tmux.conf \; display-message "tmux config reloaded"
bind | split-window -h -c "#{pane_current_path}"
bind - split-window -v -c "#{pane_current_path}"
bind c new-window -c "#{pane_current_path}"
EOF
)
  replace_managed_block "$HOME/.tmux.conf" "tmux" "$block"
}
