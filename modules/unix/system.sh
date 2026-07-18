#!/usr/bin/env bash
setup_system() {
  local current_host current_tz host_choice timezone_choice new_host new_tz
  current_host="$(hostname)"
  current_tz="$(readlink /etc/localtime 2>/dev/null | sed 's#^.*/zoneinfo/##')"
  [[ -z "$current_tz" ]] && current_tz="$(timedatectl show -p Timezone --value 2>/dev/null || echo unknown)"

  echo "Hostname:"
  echo "  1) Keep current ($current_host)"
  echo "  2) Use settings.json (${CONFIG_HOSTNAME:-not set})"
  echo "  3) Enter a custom hostname"
  read -r -p "> " host_choice
  case "$host_choice" in
    2) new_host="$CONFIG_HOSTNAME" ;;
    3) read -r -p "New hostname: " new_host ;;
    *) new_host="" ;;
  esac
  if [[ -n "$new_host" && "$new_host" != "$current_host" ]]; then
    if command -v hostnamectl >/dev/null; then sudo hostnamectl set-hostname "$new_host"
    else sudo scutil --set HostName "$new_host"; sudo scutil --set ComputerName "$new_host"; sudo scutil --set LocalHostName "$new_host"; fi
  fi

  echo "Timezone:"
  echo "  1) Keep current ($current_tz)"
  echo "  2) America/New_York"
  echo "  3) UTC"
  echo "  4) Use settings.json (${CONFIG_TIMEZONE:-not set})"
  echo "  5) Enter a custom IANA timezone"
  read -r -p "> " timezone_choice
  case "$timezone_choice" in
    2) new_tz="America/New_York" ;;
    3) new_tz="UTC" ;;
    4) new_tz="$CONFIG_TIMEZONE" ;;
    5) read -r -p "Timezone (example Europe/London): " new_tz ;;
    *) new_tz="" ;;
  esac
  if [[ -n "$new_tz" ]]; then
    if command -v timedatectl >/dev/null; then sudo timedatectl set-timezone "$new_tz"
    else sudo systemsetup -settimezone "$new_tz"; fi
  fi
}
