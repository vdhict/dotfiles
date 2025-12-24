# Dotfiles Development Notes

## Overview

Custom dotfiles for vdhict combining:
- **felipecrs/dotfiles**: Environment detection, rootmoi, Windows integration
- **szinn/dotfiles**: Fish shell, 1Password SSH integration

## Issues Fixed

### Issue 1: Docker not auto-detecting minimum mode - FIXED
- Added `/.dockerenv` file detection using `stat`
- Now auto-detects Docker containers without prompting

### Issue 2: Name/email prompts every time - FIXED
- Hardcoded name/email values (no prompts at all)
- User requested never to be asked for these

### Issue 3: Minimum mode asks instead of auto-detecting - FIXED
- Minimum mode now auto-enables for all containers and unsupported OS
- No prompts - fully automatic

### Issue 4: 1Password not available in Docker - FIXED
- Skip 1Password CLI installation in devcontainers
- Skip SSH key templates in devcontainers
- Skip 1Password fish config in devcontainers
- Disable git commit signing in devcontainers

### Issue 5: Timezone prompts in Docker - FIXED
- Set TZ=Europe/Amsterdam by default
- Set DEBIAN_FRONTEND=noninteractive

## User Configuration

- **Name**: Sander van der Heijden
- **Email**: sheijden@vdh-ict.nl
- **GitHub username**: vdhict
- **1Password vault**: Employee
- **1Password SSH item**: Git Signing Key
- **Platforms**: Ubuntu, WSL, Devcontainers, headless, macOS

## Key Design Decisions

1. **Fish shell** (not ZSH) with Starship prompt
2. **1Password** for SSH keys and git signing
3. **Cursor** editor (not VS Code or Neovim)
4. **Rootmoi** for system-level config on Linux
5. **Full K8s tooling**: kubectl, helm, k9s, krew, Flux, stern
6. **mise** for runtimes: Node.js, Python, Go, Rust

## File Structure

```
dotfiles-vdhict/
├── home/                    # User config (chezmoi source)
│   ├── .chezmoi.yaml.tmpl   # Main config
│   ├── .chezmoiscripts/     # Installation scripts
│   ├── dot_config/fish/     # Fish shell
│   ├── dot_config/git/      # Git with SSH signing
│   └── private_dot_ssh/     # 1Password SSH templates
├── root/                    # System config (Linux only)
├── windows/                 # Windows Terminal, PowerShell
└── scripts/                 # Installation scripts
```

## Testing

```bash
# Minimum mode (Docker)
docker run -it --rm ubuntu:24.04 bash -c "
  apt-get update && apt-get install -y curl git
  bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/vdhict/dotfiles/main/scripts/install_dotfiles.sh)\"
"

# Full mode (WSL or fresh Ubuntu)
wsl --import Ubuntu-Test C:\WSL\Ubuntu-Test Ubuntu-clean.tar
wsl -d Ubuntu-Test
```

## Changelog

### 2025-12-24
- Initial creation of dotfiles repository
- Fixed YAML parsing error (template comment syntax)
- Fixed Docker detection: now checks for `/.dockerenv` file
- Fixed prompts: hardcoded name/email - no prompts at all
- Fixed minimum mode: auto-detects, no prompting
- Simplified `.chezmoi.yaml.tmpl` significantly
- Added devcontainer detection to skip 1Password features:
  - Skip 1Password CLI installation script
  - Skip SSH key templates (id_ed25519, allowed_signers)
  - Skip 1Password fish config
  - Disable git commit signing (gpgSign = false in containers)
- Added timezone configuration (Europe/Amsterdam)
- Set DEBIAN_FRONTEND=noninteractive for apt
