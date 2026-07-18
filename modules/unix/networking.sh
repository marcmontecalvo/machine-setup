#!/usr/bin/env bash
setup_networking() {
  if command -v brew >/dev/null; then
    brew install nmap iperf3 mtr tcpdump bind netcat
  elif command -v apt-get >/dev/null; then
    sudo apt-get update && sudo apt-get install -y dnsutils iproute2 iputils-ping traceroute mtr-tiny nmap netcat-openbsd tcpdump whois iperf3 ethtool
  elif command -v dnf >/dev/null; then
    sudo dnf install -y bind-utils iproute iputils traceroute mtr nmap nmap-ncat tcpdump whois iperf3 ethtool
  elif command -v pacman >/dev/null; then
    sudo pacman -Sy --needed --noconfirm bind iproute2 iputils traceroute mtr nmap openbsd-netcat tcpdump whois iperf3 ethtool
  else
    echo "Unsupported package manager." >&2; return 1
  fi
}
