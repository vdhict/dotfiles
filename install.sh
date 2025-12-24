#!/bin/bash
# Dotfiles installation script
# This script installs chezmoi and applies the dotfiles

set -euo pipefail

DOTFILES_DIR="${HOME}/.dotfiles"
CHEZMOI_BIN="${HOME}/.local/bin/chezmoi"

echo "==> Installing dotfiles..."

# Ensure ~/.local/bin exists
mkdir -p "${HOME}/.local/bin"

# Install chezmoi if not present
install_chezmoi() {
  local bin_dir="${HOME}/.local/bin"

  # Try official installer first
  if bash -c "$(curl -fsLS get.chezmoi.io)" -- -b "$bin_dir" 2>/dev/null; then
    return 0
  fi

  # Fallback: download directly from GitHub releases
  echo "Trying direct download from GitHub..."
  local arch
  case "$(uname -m)" in
    x86_64) arch="amd64" ;;
    aarch64|arm64) arch="arm64" ;;
    armv7l) arch="arm" ;;
    *) echo "Unsupported architecture: $(uname -m)"; return 1 ;;
  esac

  local os
  case "$(uname -s)" in
    Linux) os="linux" ;;
    Darwin) os="darwin" ;;
    *) echo "Unsupported OS: $(uname -s)"; return 1 ;;
  esac

  local url="https://github.com/twpayne/chezmoi/releases/latest/download/chezmoi-${os}-${arch}"
  if curl -fsSL "$url" -o "${bin_dir}/chezmoi"; then
    chmod +x "${bin_dir}/chezmoi"
    return 0
  fi

  return 1
}

if ! command -v chezmoi &>/dev/null && [[ ! -x "${CHEZMOI_BIN}" ]]; then
  echo "==> Installing chezmoi..."
  installed=false
  for i in 1 2 3; do
    if install_chezmoi; then
      installed=true
      break
    fi
    echo "Retry $i/3..."
    sleep 3
  done
  if [[ "$installed" != "true" ]]; then
    echo "ERROR: Failed to install chezmoi after 3 attempts"
    exit 1
  fi
fi

# Add to PATH for this session
export PATH="${HOME}/.local/bin:${PATH}"

# Determine source directory
if [[ -d "${DOTFILES_DIR}" ]]; then
  SOURCE_DIR="${DOTFILES_DIR}"
elif [[ -d "$(dirname "$0")" ]]; then
  SOURCE_DIR="$(cd "$(dirname "$0")" && pwd)"
else
  echo "ERROR: Could not determine source directory"
  exit 1
fi

echo "==> Source directory: ${SOURCE_DIR}"

# Initialize and apply chezmoi
echo "==> Running chezmoi init --apply..."
chezmoi init --apply --source="${SOURCE_DIR}/home" "$@"

echo ""
echo "==> Dotfiles installation complete!"
echo ""
echo "Next steps:"
echo "  1. Restart your shell or run: exec fish"
echo "  2. If using 1Password SSH, ensure 1Password CLI is configured:"
echo "     - Open 1Password app"
echo "     - Go to Settings > Developer"
echo "     - Enable 'Integrate with 1Password CLI'"
echo ""
