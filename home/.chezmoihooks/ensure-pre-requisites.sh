#!/bin/bash

set -euo pipefail

# Set timezone to avoid interactive prompts
export TZ="Europe/Amsterdam"
export DEBIAN_FRONTEND="noninteractive"

# Helper: run command with sudo if available and not root
run_privileged() {
  if [[ $EUID -eq 0 ]]; then
    "$@"
  elif command -v sudo &>/dev/null; then
    sudo "$@"
  else
    echo "Warning: Cannot run '$*' - not root and sudo not available"
    return 1
  fi
}

# Configure timezone if not set (for Docker/fresh systems)
configure_timezone() {
  if [[ -f /etc/timezone ]]; then
    current_tz=$(cat /etc/timezone 2>/dev/null || echo "")
    if [[ "$current_tz" != "$TZ" ]]; then
      echo "Setting timezone to $TZ..."
      echo "$TZ" | run_privileged tee /etc/timezone >/dev/null
      run_privileged ln -sf "/usr/share/zoneinfo/$TZ" /etc/localtime 2>/dev/null || true
    fi
  fi
}

install_packages_apt() {
  local packages=("$@")
  local to_install=()

  for pkg in "${packages[@]}"; do
    if ! dpkg -s "$pkg" &>/dev/null; then
      to_install+=("$pkg")
    fi
  done

  if [[ ${#to_install[@]} -gt 0 ]]; then
    echo "Installing prerequisites: ${to_install[*]}"
    run_privileged apt-get update
    run_privileged env DEBIAN_FRONTEND=noninteractive apt-get install -y "${to_install[@]}"
  fi
}

install_packages_brew() {
  local packages=("$@")

  for pkg in "${packages[@]}"; do
    if ! brew list "$pkg" &>/dev/null; then
      echo "Installing $pkg via Homebrew..."
      brew install "$pkg"
    fi
  done
}

# Detect OS and install prerequisites
if [[ -f /etc/os-release ]]; then
  . /etc/os-release

  case "$ID" in
    ubuntu|debian)
      configure_timezone
      install_packages_apt git curl fish
      ;;
    alpine)
      if ! command -v git &>/dev/null || ! command -v curl &>/dev/null || ! command -v fish &>/dev/null; then
        echo "Installing prerequisites..."
        run_privileged apk add --no-cache git curl fish tzdata
        # Set timezone on Alpine
        if [[ -f "/usr/share/zoneinfo/$TZ" ]]; then
          run_privileged cp "/usr/share/zoneinfo/$TZ" /etc/localtime
          echo "$TZ" | run_privileged tee /etc/timezone >/dev/null
        fi
      fi
      ;;
  esac
elif [[ "$(uname)" == "Darwin" ]]; then
  # macOS - ensure Homebrew is available
  if ! command -v brew &>/dev/null; then
    echo "Homebrew not found. Please install it first:"
    echo '  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
    exit 1
  fi

  install_packages_brew git fish
fi

echo "Prerequisites installed successfully!"
