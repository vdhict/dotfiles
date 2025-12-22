# vdhict's Dotfiles

Cross-platform dotfiles managed with [chezmoi](https://chezmoi.io), featuring Fish shell, 1Password SSH integration, and Cursor editor support.

## Features

- **Shell**: Fish with Starship prompt
- **Editor**: Cursor (VS Code fork with Claude integration)
- **SSH Keys**: 1Password integration for SSH key management and git signing
- **Package Management**: Homebrew (macOS & Linux)
- **Platforms**: Ubuntu, WSL, Devcontainers, headless servers, macOS

## Quick Install

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/vdhict/dotfiles/main/scripts/install_dotfiles.sh)"
```

Or with wget:

```bash
sh -c "$(wget -qO- https://raw.githubusercontent.com/vdhict/dotfiles/main/scripts/install_dotfiles.sh)"
```

## Manual Installation

```bash
git clone https://github.com/vdhict/dotfiles.git ~/.dotfiles
~/.dotfiles/install.sh
```

## What's Included

### Shell & Terminal

- **Fish shell** with modular conf.d configuration
- **Starship** cross-platform prompt
- **Fisher** plugin manager with useful plugins
- **FiraCode Nerd Font** for terminal icons

### Development Tools

- **mise** for runtime version management (Node.js, Python, Go, Rust)
- **Git** with SSH signing via 1Password
- **Cursor** editor with WSL integration

### Kubernetes (Full tooling)

- kubectl, kubectx, kubens
- Helm
- k9s (TUI)
- krew (plugin manager)
- stern (log tailing)
- Flux CD

### CLI Utilities

- fzf, ripgrep, fd, eza, bat, zoxide, atuin
- jq, yq, httpie
- lazygit, gh (GitHub CLI)

## Platform Support

| Platform | Status | Notes |
|----------|--------|-------|
| Ubuntu (20.04, 22.04, 24.04) | Full | All features |
| macOS (Intel & Apple Silicon) | Full | All features |
| WSL | Full | Windows Terminal & font integration |
| Devcontainers | Minimum | Shell & basic tools only |
| Headless servers | Full | No GUI-specific features |

## 1Password SSH Setup

This dotfiles uses 1Password for SSH key management and git commit signing.

### Prerequisites

1. 1Password account with CLI access
2. SSH key stored in 1Password (Vault: `Employee`, Item: `Git Signing Key`)

### Required 1Password Fields

Your 1Password SSH key item should have:

- `private key` - Your SSH private key
- `public key` - Your SSH public key

### Enabling CLI Integration

1. Open 1Password desktop app
2. Go to **Settings > Developer**
3. Enable **Integrate with 1Password CLI**
4. (macOS) Enable **Use the SSH agent**

### Testing

```bash
# Verify 1Password CLI works
op whoami

# Test SSH key
ssh -T git@github.com

# Test git signing
git log --show-signature -1
```

## Configuration

### Environment Detection

The dotfiles automatically detect your environment:

- **is_ubuntu**: Ubuntu Linux
- **is_macos**: macOS
- **is_wsl**: Windows Subsystem for Linux
- **is_devcontainer**: GitHub Codespaces, Gitpod, VS Code Remote Containers
- **is_headless**: SSH session without display

### Minimum Mode

Minimum mode installs only essential shell configuration. It's automatically enabled for:

- Devcontainers
- Non-supported Linux distributions

### Customization

Edit `~/.dotfiles/home/.chezmoi.yaml.tmpl` to change:

- Your name and email
- 1Password vault and item names
- Default editor

## Directory Structure

```
dotfiles/
├── home/                    # User home directory (chezmoi source)
│   ├── .chezmoi.yaml.tmpl  # Main configuration
│   ├── .chezmoiscripts/    # Installation scripts
│   ├── dot_config/
│   │   ├── fish/           # Fish shell config
│   │   ├── git/            # Git configuration
│   │   ├── starship/       # Prompt configuration
│   │   ├── homebrew/       # Brewfile
│   │   └── cursor/         # Editor settings
│   └── private_dot_ssh/    # SSH config (1Password templates)
├── root/                    # System config (Linux only)
│   ├── .chezmoiscripts/    # System setup scripts
│   └── etc/                # System configuration files
├── windows/                 # Windows host configuration
│   ├── powershell/         # PowerShell profile
│   └── terminal/           # Windows Terminal settings
└── scripts/                 # Utility scripts
```

## Useful Commands

```bash
# Chezmoi
chezmoi status       # Show what would change
chezmoi diff         # Show detailed diff
chezmoi apply        # Apply changes
chezmoi update       # Pull and apply latest
chezmoi edit         # Edit source files

# Fish
fisher list          # List installed plugins
fisher update        # Update all plugins

# 1Password
op signin            # Sign in to 1Password
op whoami            # Check current session
```

## Troubleshooting

### 1Password CLI not working

```bash
# Check if CLI is installed
op --version

# Sign in manually
op signin

# Verify integration is enabled
op vault list
```

### SSH key not loading

1. Ensure 1Password app is unlocked
2. Check CLI integration is enabled
3. Verify item path: `op://Employee/Git Signing Key/private key`

### Fish not set as default shell

```bash
# Add fish to shells if needed
echo $(which fish) | sudo tee -a /etc/shells

# Change default shell
chsh -s $(which fish)
```

## Credits

This dotfiles setup is inspired by and borrows from:

- [felipecrs/dotfiles](https://github.com/felipecrs/dotfiles) - Rootmoi, environment detection, Windows integration
- [szinn/dotfiles](https://github.com/szinn/dotfiles) - 1Password SSH integration, Fish configuration

## License

MIT
