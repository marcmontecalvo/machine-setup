#!/usr/bin/env bash
set -Eeuo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SETTINGS_FILE="$ROOT_DIR/config/settings.json"

if [[ ! -f "$SETTINGS_FILE" ]]; then
  echo "Missing settings file: $SETTINGS_FILE" >&2
  exit 1
fi

json_value() {
  local key="$1"
  sed -nE 's/^[[:space:]]*"'"$key"'"[[:space:]]*:[[:space:]]*"([^"]*)".*/\1/p' "$SETTINGS_FILE" | head -n 1
}

GIT_NAME="$(json_value name)"
GIT_EMAIL="$(json_value email)"
GITHUB_USERNAME="$(json_value github_username)"
GIT_DEFAULT_BRANCH="$(json_value default_branch)"

if [[ -z "$GIT_NAME" || -z "$GIT_EMAIL" || -z "$GITHUB_USERNAME" ]]; then
  echo "Complete config/settings.json before running setup." >&2
  exit 1
fi

if [[ "$GIT_NAME" == "Your Name" || "$GIT_EMAIL" == "you@example.com" || "$GITHUB_USERNAME" == "your-github-username" ]]; then
  echo "Replace the placeholder values in config/settings.json before running setup." >&2
  exit 1
fi

GIT_DEFAULT_BRANCH="${GIT_DEFAULT_BRANCH:-main}"
export GIT_NAME GIT_EMAIL GITHUB_USERNAME GIT_DEFAULT_BRANCH

AVAILABLE=(git history tools shell)
if (( $# == 0 )); then
  SELECTED=("${AVAILABLE[@]}")
else
  SELECTED=("$@")
fi

for module in "${SELECTED[@]}"; do
  case "$module" in
    git|history|tools|shell)
      echo "==> Running $module"
      # shellcheck source=/dev/null
      source "$ROOT_DIR/modules/unix/$module.sh"
      "setup_$module"
      ;;
    *)
      echo "Unknown module: $module" >&2
      echo "Available: ${AVAILABLE[*]}" >&2
      exit 1
      ;;
  esac
done

echo "Setup complete. Open a new shell to load all changes."
