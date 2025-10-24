#!/usr/bin/env bash

set -euo pipefail

log() {
  echo "[bootstrap] $*"
}

ensure_swap() {
  local swapfile=/swapfile
  if swapon --noheadings --show=NAME | grep -qx "${swapfile}"; then
    log "Swap file already active at ${swapfile}."
    return
  fi

  if [[ -f ${swapfile} ]]; then
    log "Existing swap file found. Trying to activate..."
    sudo chmod 600 "${swapfile}"
    if sudo swapon "${swapfile}" 2>/dev/null; then
      log "Swap file activated."
    else
      log "Existing swap file is unusable. Recreating..."
      sudo dd if=/dev/zero of="${swapfile}" bs=1M count=2048 status=progress
      sudo chmod 600 "${swapfile}"
      sudo mkswap "${swapfile}" >/dev/null
      sudo swapon "${swapfile}"
    fi
  else
    log "Creating swap file at ${swapfile}..."
    sudo dd if=/dev/zero of="${swapfile}" bs=1M count=2048 status=progress
    sudo chmod 600 "${swapfile}"
    sudo mkswap "${swapfile}" >/dev/null
    sudo swapon "${swapfile}"
  fi

  if ! grep -q "^${swapfile} " /etc/fstab; then
    echo "${swapfile} none swap sw 0 0" | sudo tee -a /etc/fstab >/dev/null
  fi

  log "Swap file ready."
}

open_port() {
  local port=$1
  if sudo iptables -C INPUT -p udp --dport "${port}" -j ACCEPT 2>/dev/null; then
    log "Firewall already allows UDP port ${port}."
  else
    log "Allowing UDP port ${port}..."
    sudo iptables -A INPUT -p udp --dport "${port}" -j ACCEPT
    sudo netfilter-persistent save >/dev/null
    sudo netfilter-persistent reload >/dev/null
  fi
}

log "Setting up swap..."
ensure_swap

log "Configuring firewall..."
open_port 30000

log "Initialization complete."
