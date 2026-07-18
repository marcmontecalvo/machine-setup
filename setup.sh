#!/usr/bin/env bash
set -Eeuo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=config/settings.env
source "$ROOT_DIR/config/settings.env"

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
