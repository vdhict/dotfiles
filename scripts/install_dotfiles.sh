#!/bin/bash
# Convenience script for one-liner installation
# Usage: bash -c "$(curl -fsSL https://raw.githubusercontent.com/vdhict/dotfiles/main/scripts/install_dotfiles.sh)"

set -euo pipefail

# Set timezone and non-interactive mode for apt
export TZ="${TZ:-Europe/Amsterdam}"
export DEBIAN_FRONTEND="noninteractive"

# Configuration
DOTFILES_REPO_HOST="${DOTFILES_REPO_HOST:-https://github.com}"
DOTFILES_USER="${DOTFILES_USER:-vdhict}"
DOTFILES_REPO="${DOTFILES_REPO:-dotfiles}"
DOTFILES_BRANCH="${DOTFILES_BRANCH:-main}"
DOTFILES_DIR="${HOME}/.dotfiles"

echo "==> Dotfiles Installation Script"
echo "    Repository: ${DOTFILES_REPO_HOST}/${DOTFILES_USER}/${DOTFILES_REPO}"
echo "    Branch: ${DOTFILES_BRANCH}"
echo ""

# Check for git
if ! command -v git &>/dev/null; then
  echo "==> Git not found, attempting to install..."

  if command -v apt-get &>/dev/null; then
    sudo apt-get update && sudo apt-get install -y git
  elif command -v brew &>/dev/null; then
    brew install git
  elif command -v apk &>/dev/null; then
    sudo apk add --no-cache git
  else
    echo "ERROR: Cannot install git automatically. Please install git first."
    exit 1
  fi
fi

# Clone or update repository
if [[ -d "${DOTFILES_DIR}" ]]; then
  echo "==> Dotfiles directory exists, updating..."
  cd "${DOTFILES_DIR}"
  git fetch origin
  git checkout "${DOTFILES_BRANCH}"
  git pull origin "${DOTFILES_BRANCH}"
else
  echo "==> Cloning dotfiles repository..."
  git clone --branch "${DOTFILES_BRANCH}" \
    "${DOTFILES_REPO_HOST}/${DOTFILES_USER}/${DOTFILES_REPO}.git" \
    "${DOTFILES_DIR}"
fi

# Run installation
echo "==> Running installation script..."
"${DOTFILES_DIR}/install.sh" "$@"
