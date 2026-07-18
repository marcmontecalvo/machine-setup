$ErrorActionPreference='Stop'
if (-not (Get-Command wsl.exe -ErrorAction SilentlyContinue)) {
    Write-Warning 'tmux requires WSL on Windows. Install WSL first with: wsl --install'
    return
}
wsl.exe sh -lc 'if command -v apt-get >/dev/null 2>&1; then sudo apt-get update && sudo apt-get install -y tmux; elif command -v dnf >/dev/null 2>&1; then sudo dnf install -y tmux; elif command -v pacman >/dev/null 2>&1; then sudo pacman -Sy --needed --noconfirm tmux; else echo "Unsupported WSL distribution" >&2; exit 1; fi; cat > ~/.tmux.conf <<"EOF"
set -g mouse on
set -g history-limit 100000
set -g base-index 1
setw -g pane-base-index 1
set -g renumber-windows on
set -g escape-time 10
setw -g mode-keys vi
bind r source-file ~/.tmux.conf \; display-message "tmux config reloaded"
bind | split-window -h -c "#{pane_current_path}"
bind - split-window -v -c "#{pane_current_path}"
bind c new-window -c "#{pane_current_path}"
EOF'
