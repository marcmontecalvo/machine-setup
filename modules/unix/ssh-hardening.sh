#!/usr/bin/env bash
setup_ssh_hardening() {
  [[ "$(uname -s)" == "Darwin" ]] && { echo "SSH hardening module currently targets systemd-based Linux; skipping macOS."; return; }
  if command -v apt-get >/dev/null; then sudo apt-get update && sudo apt-get install -y openssh-server
  elif command -v dnf >/dev/null; then sudo dnf install -y openssh-server
  elif command -v pacman >/dev/null; then sudo pacman -Sy --needed --noconfirm openssh
  else echo "Unsupported package manager." >&2; return 1; fi
  local root="no" password="no"
  [[ "$SSH_PERMIT_ROOT_LOGIN" == "True" || "$SSH_PERMIT_ROOT_LOGIN" == "true" ]] && root="yes"
  [[ "$SSH_PASSWORD_AUTHENTICATION" == "True" || "$SSH_PASSWORD_AUTHENTICATION" == "true" ]] && password="yes"
  sudo install -d -m 755 /etc/ssh/sshd_config.d
  sudo tee /etc/ssh/sshd_config.d/99-machine-setup.conf >/dev/null <<EOF
Port ${SSH_PORT:-22}
PermitRootLogin $root
PasswordAuthentication $password
KbdInteractiveAuthentication no
PubkeyAuthentication yes
X11Forwarding no
AllowTcpForwarding yes
ClientAliveInterval 300
ClientAliveCountMax 2
EOF
  sudo sshd -t
  sudo systemctl enable ssh 2>/dev/null || sudo systemctl enable sshd
  sudo systemctl restart ssh 2>/dev/null || sudo systemctl restart sshd
}
