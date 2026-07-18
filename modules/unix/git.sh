#!/usr/bin/env bash

setup_git() {
  if ! command -v git >/dev/null 2>&1; then
    if command -v apt-get >/dev/null 2>&1; then
      sudo apt-get update && sudo apt-get install -y git curl openssh-client
    elif command -v dnf >/dev/null 2>&1; then
      sudo dnf install -y git curl openssh-clients
    elif command -v yum >/dev/null 2>&1; then
      sudo yum install -y git curl openssh-clients
    elif command -v pacman >/dev/null 2>&1; then
      sudo pacman -Sy --needed --noconfirm git curl openssh
    elif command -v brew >/dev/null 2>&1; then
      brew install git
    else
      echo "No supported package manager found; install Git manually." >&2
      return 1
    fi
  fi

  git config --global user.name "$GIT_NAME"
  git config --global user.email "$GIT_EMAIL"
  git config --global init.defaultBranch main
  git config --global pull.ff only
  git config --global fetch.prune true
  git config --global rebase.autoStash true
  git config --global rerere.enabled true
  git config --global core.autocrlf input

  mkdir -p "$HOME/.ssh"
  chmod 700 "$HOME/.ssh"
  local key_url="https://github.com/${GITHUB_USERNAME}.keys"
  local fetched_keys
  fetched_keys="$(curl --fail --silent --show-error "$key_url")"

  if [[ -z "$fetched_keys" ]]; then
    echo "No public SSH keys found at $key_url" >&2
    return 1
  fi

  touch "$HOME/.ssh/authorized_keys"
  chmod 600 "$HOME/.ssh/authorized_keys"
  while IFS= read -r key; do
    [[ -z "$key" ]] && continue
    grep -qxF "$key" "$HOME/.ssh/authorized_keys" || printf '%s\n' "$key" >> "$HOME/.ssh/authorized_keys"
  done <<< "$fetched_keys"
}
