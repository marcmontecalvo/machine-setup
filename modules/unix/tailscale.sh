#!/usr/bin/env bash
setup_tailscale() {
  if command -v tailscale >/dev/null; then echo "Tailscale already installed."; else
    if [[ "$(uname -s)" == "Darwin" ]]; then
      command -v brew >/dev/null || { echo "Homebrew is required." >&2; return 1; }
      brew install --cask tailscale-app
    else
      curl -fsSL https://tailscale.com/install.sh | sh
    fi
  fi
  echo "Run 'sudo tailscale up' (Linux) or open the Tailscale app (macOS) to authenticate."
}
