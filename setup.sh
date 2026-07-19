#!/usr/bin/env bash
set -Eeuo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SETTINGS_FILE="$ROOT_DIR/config/settings.json"
# shellcheck source=lib/unix/config.sh
source "$ROOT_DIR/lib/unix/config.sh"
AVAILABLE=(git history tools shell docker ssh-hardening tailscale github-cli starship direnv zoxide eza tmux networking system)
DESCRIPTIONS=(
  "Git, identity, defaults, and GitHub public SSH keys"
  "Prefix-based shell history search"
  "Core command-line tools"
  "Shell aliases and quality-of-life defaults"
  "Docker Engine/Desktop and Compose"
  "OpenSSH server with conservative hardening"
  "Tailscale client"
  "GitHub CLI installation and authentication"
  "Starship cross-shell prompt"
  "Per-directory environment loading"
  "Smart directory jumping"
  "Modern ls replacement"
  "Persistent terminal sessions and configuration"
  "Common DNS, routing, socket, and packet tools"
  "Interactive hostname and timezone configuration"
)

[[ -f "$SETTINGS_FILE" ]] || { echo "Missing settings file: $SETTINGS_FILE" >&2; exit 1; }

json_string() {
  local path="$1"
  python3 - "$SETTINGS_FILE" "$path" <<'PY'
import json, sys
with open(sys.argv[1], encoding="utf-8") as f:
    data=json.load(f)
value=data
for key in sys.argv[2].split('.'):
    value=value.get(key, '') if isinstance(value, dict) else ''
print(value if value is not None else '')
PY
}

GIT_NAME="$(json_string user.name)"
GIT_EMAIL="$(json_string user.email)"
GITHUB_USERNAME="$(json_string user.github_username)"
GIT_DEFAULT_BRANCH="$(json_string git.default_branch)"
SSH_PORT="$(json_string ssh.port)"
SSH_PERMIT_ROOT_LOGIN="$(json_string ssh.permit_root_login)"
SSH_PASSWORD_AUTHENTICATION="$(json_string ssh.password_authentication)"
CONFIG_HOSTNAME="$(json_string system.hostname)"
CONFIG_TIMEZONE="$(json_string system.timezone)"
export ROOT_DIR SETTINGS_FILE GIT_NAME GIT_EMAIL GITHUB_USERNAME GIT_DEFAULT_BRANCH SSH_PORT SSH_PERMIT_ROOT_LOGIN SSH_PASSWORD_AUTHENTICATION CONFIG_HOSTNAME CONFIG_TIMEZONE

if [[ "$GIT_NAME" == "Your Name" || "$GIT_EMAIL" == "you@example.com" || "$GITHUB_USERNAME" == "your-github-username" ]]; then
  echo "Replace the placeholder identity values in config/settings.json before running setup." >&2
  exit 1
fi

choose_modules() {
  local -a enabled=()
  local input index
  for ((index=0; index<${#AVAILABLE[@]}; index++)); do enabled[index]=1; done
  enabled[5]=0
  enabled[14]=0
  while true; do
    clear 2>/dev/null || true
    echo "Machine Setup"
    echo "Toggle modules by number. A=all, N=none, R=run, Q=quit."
    echo "SSH hardening and system identity changes are off by default."
    echo
    for ((index=0; index<${#AVAILABLE[@]}; index++)); do
      printf '%2d. [%s] %-15s %s\n' "$((index+1))" "$([[ ${enabled[index]} -eq 1 ]] && echo x || echo ' ')" "${AVAILABLE[index]}" "${DESCRIPTIONS[index]}"
    done
    echo
    read -r -p "> " input
    case "${input,,}" in
      a) for ((index=0; index<${#AVAILABLE[@]}; index++)); do enabled[index]=1; done ;;
      n) for ((index=0; index<${#AVAILABLE[@]}; index++)); do enabled[index]=0; done ;;
      r|'')
        SELECTED=()
        for ((index=0; index<${#AVAILABLE[@]}; index++)); do [[ ${enabled[index]} -eq 1 ]] && SELECTED+=("${AVAILABLE[index]}"); done
        return ;;
      q) exit 0 ;;
      *)
        if [[ "$input" =~ ^[0-9]+$ ]] && (( input >= 1 && input <= ${#AVAILABLE[@]} )); then
          index=$((input-1)); enabled[index]=$((1-enabled[index]))
        fi
        ;;
    esac
  done
}

if (( $# == 0 )); then choose_modules; else SELECTED=("$@"); fi

for module in "${SELECTED[@]}"; do
  [[ " ${AVAILABLE[*]} " == *" $module "* ]] || { echo "Unknown module: $module" >&2; exit 1; }
  echo "==> Running $module"
  # shellcheck source=/dev/null
  source "$ROOT_DIR/modules/unix/$module.sh"
  "setup_${module//-/_}"
done

echo "Setup complete. Open a new shell to load shell changes."
