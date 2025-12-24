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
if ! command -v chezmoi &>/dev/null && [[ ! -x "${CHEZMOI_BIN}" ]]; then
  echo "==> Installing chezmoi..."
  for i in 1 2 3; do
    if bash -c "$(curl -fsLS get.chezmoi.io)" -- -b "${HOME}/.local/bin"; then
      break
    fi
    echo "Retry $i/3..."
    sleep 2
  done
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
