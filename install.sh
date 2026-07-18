#!/usr/bin/env bash
set -Eeuo pipefail

REPOSITORY="marcmontecalvo/machine-setup"
BRANCH="${MACHINE_SETUP_BRANCH:-main}"
INSTALL_DIR="${MACHINE_SETUP_HOME:-$HOME/.local/share/machine-setup}"
ARCHIVE_URL="https://github.com/${REPOSITORY}/archive/refs/heads/${BRANCH}.tar.gz"
TTY="/dev/tty"

if [[ ! -r "$TTY" ]]; then
  echo "An interactive terminal is required." >&2
  exit 1
fi

for command in curl tar; do
  if ! command -v "$command" >/dev/null 2>&1; then
    echo "Required command not found: $command" >&2
    exit 1
  fi
done

TEMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TEMP_DIR"' EXIT

printf 'Downloading machine-setup...\n'
curl -fsSL "$ARCHIVE_URL" | tar -xz -C "$TEMP_DIR"
SOURCE_DIR="$(find "$TEMP_DIR" -mindepth 1 -maxdepth 1 -type d | head -n 1)"
[[ -n "$SOURCE_DIR" ]] || { echo "Unable to locate downloaded files." >&2; exit 1; }

SAVED_SETTINGS=""
if [[ -f "$INSTALL_DIR/config/settings.json" ]]; then
  SAVED_SETTINGS="$TEMP_DIR/settings.json"
  cp "$INSTALL_DIR/config/settings.json" "$SAVED_SETTINGS"
fi

mkdir -p "$(dirname "$INSTALL_DIR")"
rm -rf "$INSTALL_DIR"
mkdir -p "$INSTALL_DIR"
cp -R "$SOURCE_DIR"/. "$INSTALL_DIR"/

if [[ -n "$SAVED_SETTINGS" ]]; then
  cp "$SAVED_SETTINGS" "$INSTALL_DIR/config/settings.json"
  printf 'Preserved existing settings.\n'
else
  printf '\nFirst-run configuration\n'
  read -r -p 'Full name: ' USER_NAME <"$TTY"
  read -r -p 'Email address: ' USER_EMAIL <"$TTY"
  read -r -p 'GitHub username: ' GITHUB_USERNAME <"$TTY"
  read -r -p 'Default Git branch [main]: ' DEFAULT_BRANCH <"$TTY"
  DEFAULT_BRANCH="${DEFAULT_BRANCH:-main}"

  if [[ -z "$USER_NAME" || -z "$USER_EMAIL" || -z "$GITHUB_USERNAME" ]]; then
    echo "Name, email, and GitHub username are required." >&2
    exit 1
  fi

  if ! command -v python3 >/dev/null 2>&1; then
    echo "python3 is required to create and read config/settings.json." >&2
    echo "Install Python 3, then rerun this command." >&2
    exit 1
  fi

  SETTINGS_PATH="$INSTALL_DIR/config/settings.json" \
  USER_NAME="$USER_NAME" USER_EMAIL="$USER_EMAIL" \
  GITHUB_USERNAME="$GITHUB_USERNAME" DEFAULT_BRANCH="$DEFAULT_BRANCH" \
  python3 <<'PY'
import json
import os
from pathlib import Path

settings = {
    "user": {
        "name": os.environ["USER_NAME"],
        "email": os.environ["USER_EMAIL"],
        "github_username": os.environ["GITHUB_USERNAME"],
    },
    "git": {"default_branch": os.environ["DEFAULT_BRANCH"]},
    "ssh": {
        "port": 22,
        "permit_root_login": False,
        "password_authentication": False,
    },
    "system": {"hostname": "", "timezone": ""},
}
Path(os.environ["SETTINGS_PATH"]).write_text(
    json.dumps(settings, indent=2) + "\n", encoding="utf-8"
)
PY
fi

chmod +x "$INSTALL_DIR/setup.sh" "$INSTALL_DIR/install.sh"
printf 'Installed to %s\n\n' "$INSTALL_DIR"
exec bash "$INSTALL_DIR/setup.sh" <"$TTY" >"$TTY" 2>"$TTY"
