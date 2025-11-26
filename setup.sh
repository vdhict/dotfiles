#!/usr/bin/env bash

set -Eeuo pipefail

declare -r DOTFILES_REPO_URL="https://github.com/vdhict/dotfiles"
declare -r ostype="$(uname)"
declare -r arch="$(uname -p)"

function initialize_os_env() {
  if [[ "${ostype}" == "Darwin" ]]; then
    initialize_macos
  elif [[ "${ostype}" == "Linux" ]]; then
    initialize_linux
  else
    echo "Invalid OS type: ${ostype}" >&2
    exit 1
  fi
}

function initialize_macos() {
  function install_xcode() {
    local git_cmd_path="/Library/Developer/CommandLineTools/usr/bin/git"

    if [[ ! -e "${git_cmd_path}" ]]; then
      # Install command line developer tool
      xcode-select --install
      read -p "Press any key when the installation has completed." -n 1 -r
    else
      echo "Command line developer tools are installed."
    fi
  }

  function install_rosetta() {
    sudo softwareupdate --agree-to-license --install-rosetta
  }

  echo "Initializing MacOS..."
  install_xcode
  install_rosetta
}

function initialize_linux() {
  echo "Initializing Linux..."
}

function get_homebrew_install_dir() {
  if [[ "${ostype}" == "Darwin" ]]; then
    echo "/opt/homebrew"
  elif [[ "${ostype}" == "Linux" ]]; then
    echo "/home/linuxbrew/.linuxbrew"
  fi
}

function install_homebrew() {
  # Install Homebrew if necessary
  export HOMEBREW_CASK_OPTS=--no-quarantine
  if [[ -e "$(get_homebrew_install_dir)/bin/brew" ]]; then
    echo "Homebrew is already installed."
  else
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
}

function install_chezmoi() {
  # Install chezmoi if necessary
  if [[ -e "$(get_homebrew_install_dir)/bin/chezmoi" ]]; then
    echo "Chezmoi is already installed."
  else
    brew install chezmoi
  fi
}

function install_1password() {
  # Install 1Password if necessary
  if [[ "${ostype}" == "Darwin" ]]; then
    if [[ -e "$(get_homebrew_install_dir)/bin/op" ]]; then
      echo "1Password is already installed."
    else
      brew install --cask 1password
      brew install --cask 1password-cli
    fi
  elif [[ "${ostype}" == "Linux" ]]; then
    if [[ -e "/usr/local/bin/op" ]]; then
      echo "1Password is already installed."
    else
      brew install unzip
      if [[ "${arch}" == "aarch64" ]]; then
        wget "https://cache.agilebits.com/dist/1P/op2/pkg/v2.32.0/op_linux_arm64_v2.32.0.zip" -O op.zip && \
        unzip -d op op.zip && \
        sudo mv op/op /usr/local/bin/ && \
        rm -r op.zip op && \
        sudo groupadd -f onepassword-cli && \
        sudo chgrp onepassword-cli /usr/local/bin/op && \
        sudo chmod g+s /usr/local/bin/op
      else
        wget "https://cache.agilebits.com/dist/1P/op2/pkg/v2.32.0/op_linux_amd64_v2.32.0.zip" -O op.zip && \
        unzip -d op op.zip && \
        sudo mv op/op /usr/local/bin/ && \
        rm -r op.zip op && \
        sudo groupadd -f onepassword-cli && \
        sudo chgrp onepassword-cli /usr/local/bin/op && \
        sudo chmod g+s /usr/local/bin/op
      fi
    fi
  fi
  read -p "Please open 1Password, log into all accounts and set under Settings>CLI activate Integrate with 1Password CLI. Press any key to continue." -n 1 -r
}

function get_homebrew_shellenv() {
  $(get_homebrew_install_dir)/bin/brew shellenv
}

initialize_os_env
install_homebrew
eval "$(get_homebrew_shellenv)"
install_chezmoi
install_1password

# Apply dotfiles
echo "Applying Chezmoi configuration."
chezmoi init "${DOTFILES_REPO_URL}"
cd ~/.local/share/chezmoi
git remote set-url origin git@github.com:vdhict/dotfiles.git
chezmoi apply
╭─ WSL at    ~/.local/share/chezmoi   main ≡  ~2                                                                                  19:21:54  ─╮
╰─ /tmp/install
Initializing Linux...
Homebrew is already installed.
Chezmoi is already installed.
1Password is already installed.
Please open 1Password, log into all accounts and set under Settings>CLI activate Integrate with 1Password CLI. Press any key to continue.
Applying Chezmoi configuration.
Installing packages using Homebrew...
✔︎ JSON API cask.jws.json                           [Downloaded   15.0MB/ 15.0MB]
✔︎ JSON API formula.jws.json                        [Downloaded   31.7MB/ 31.7MB]
Installing antidote
Installing atuin
Installing bash
Installing bat
Installing cowsay
Installing diff-so-fancy
Installing eza
Installing figlet
Installing fortune
Installing gh
Installing git
Installing git-extras
Installing htop
Installing lolcat
Installing rm-improved
Installing sl
Installing thefuck
Installing tldr
Installing tmux
Installing tpm
Installing zoxide
Installing zsh
Installing talhelper
Installing cilium-cli
Installing cloudflared
Installing age
Installing flux
Installing helm
Installing sops
Using helm
Installing helmfile
Installing k9s
Installing jq
Installing kustomize
Installing kubectl
Installing kubectl-cnpg
Installing talosctl
Installing ripgrep
Installing fish
`brew bundle` complete! 39 Brewfile dependencies now installed.
Setting shell to fish...
Password:
chsh: /home/linuxbrew/.linuxbrew/bin/fish is an invalid shell
Done!
╭─ WSL at    ~/.local/share/chezmoi   main ≡  ~3                                                                 15m 7.777s     19:37:40  ─╮
╰─ /home/linuxbrew/.linuxbrew/bin/fish
Welcome to fish, the friendly interactive shell
Type help for instructions on how to use fish
sheijden@VDHSPCOP01 ~/.l/s/chezmoi (main)> exit
╭─ WSL at    ~/.local/share/chezmoi   main ≡  ~3                                                                  1m 9.159s     19:39:09  ─╮
╰─ command -v
╭─ WSL at    ~/.local/share/chezmoi   main ≡  ~3                                                                                  19:39:12  ─╮
╰─ command -v fish
╭─ WSL at    ~/.local/share/chezmoi   main ≡  ~3                                                                            ERROR  19:39:15  ─╮
╰─ cat /etc/sh
shadow   shadow-  shells
╭─ WSL at    ~/.local/share/chezmoi   main ≡  ~3                                                                            ERROR  19:39:15  ─╮
╰─ cat /etc/shells
# /etc/shells: valid login shells
/bin/sh
/bin/bash
/usr/bin/bash
/bin/rbash
/usr/bin/rbash
/usr/bin/sh
/bin/dash
/usr/bin/dash
/usr/bin/tmux
/usr/bin/screen
╭─ WSL at    ~/.local/share/chezmoi   main ≡  ~3                                                                                  19:39:23  ─╮
╰─ echo /home/linuxbrew/.linuxbrew/bin/fish | sudo tee -a /etc/shells
[sudo] password for sheijden:
/home/linuxbrew/.linuxbrew/bin/fish
╭─ WSL at    ~/.local/share/chezmoi   main ≡  ~3                                                                     3.225s     19:40:08  ─╮
╰─ cat /etc/shells
# /etc/shells: valid login shells
/bin/sh
/bin/bash
/usr/bin/bash
/bin/rbash
/usr/bin/rbash
/usr/bin/sh
/bin/dash
/usr/bin/dash
/usr/bin/tmux
/usr/bin/screen
/home/linuxbrew/.linuxbrew/bin/fish
╭─ WSL at    ~/.local/share/chezmoi   main ≡  ~3                                                                                  19:40:14  ─╮
╰─ which fish
╭─ WSL at    ~/.local/share/chezmoi   main ≡  ~3                                                                            ERROR  19:41:05  ─╮
╰─ chezmoi
Command 'chezmoi' not found, but can be installed with:
sudo snap install chezmoi
╭─ WSL at    ~/.local/share/chezmoi   main ≡  ~3                                                               572ms   NOTFOUND  19:42:35  ─╮
╰─ /home/linuxbrew/.linuxbrew/bin/chezmoi apply
Installing packages using Homebrew...
/tmp/3875407711.01-ubuntu-install-packages.sh: line 4: brew: command not found
Setting shell to fish...

Password:
chsh:  is an invalid shell
Done!
╭─ WSL at    ~/.local/share/chezmoi   main ≡  ~3                                                                     6.002s     19:42:58  ─╮
╰─ ls
README.md  home  license  setup.sh
╭─ WSL at    ~/.local/share/chezmoi   main ≡  ~3                                                                                  19:43:39  ─╮
╰─ cd ..
╭─ WSL at    ~/.local/share                                                                                                           19:43:43  ─╮
╰─ rm -r ~/.local/share/chezmoi/
rm: remove write-protected regular file '/home/sheijden/.local/share/chezmoi/.git/objects/pack/pack-0a70be32c57340c8dfdebca8a46bff99caf8b457.idx'? y^C
╭─ WSL at    ~/.local/share                                                                                         2.036s   SIGINT  19:44:08  ─╮
╰─ sudo rm -r ~/.local/share/chezmoi/
╭─ WSL at    ~/.local/share                                                                                                           19:44:12  ─╮
╰─ /tmp/install
Initializing Linux...
Homebrew is already installed.
Chezmoi is already installed.
1Password is already installed.
Please open 1Password, log into all accounts and set under Settings>CLI activate Integrate with 1Password CLI. Press any key to continue.
Applying Chezmoi configuration.
Cloning into '/home/sheijden/.local/share/chezmoi'...
remote: Enumerating objects: 44, done.
remote: Counting objects: 100% (44/44), done.
remote: Compressing objects: 100% (27/27), done.
remote: Total 44 (delta 14), reused 26 (delta 6), pack-reused 0 (from 0)
Receiving objects: 100% (44/44), 9.65 KiB | 617.00 KiB/s, done.
Resolving deltas: 100% (14/14), done.
chezmoi: .chezmoiscripts/linux/01-ubuntu-install-packages.sh: template: .chezmoiscripts/linux/run_onchange_01-ubuntu-install-packages.sh.tmpl:6:18: executing ".chezmoiscripts/linux/run_onchange_01-ubuntu-install-packages.sh.tmpl" at <.packages.ubuntu.brews>: map has no entry for key "packages"
╭─ WSL at    ~/.local/share                                                                                          2.243s   ERROR  19:44:19  ─╮
╰─ cat /tmp/install
#!/usr/bin/env bash

set -Eeuo pipefail

declare -r DOTFILES_REPO_URL="https://github.com/vdhict/dotfiles"
declare -r ostype="$(uname)"
declare -r arch="$(uname -p)"

function initialize_os_env() {
  if [[ "${ostype}" == "Darwin" ]]; then
    initialize_macos
  elif [[ "${ostype}" == "Linux" ]]; then
    initialize_linux
  else
    echo "Invalid OS type: ${ostype}" >&2
    exit 1
  fi
}

function initialize_macos() {
  function install_xcode() {
    local git_cmd_path="/Library/Developer/CommandLineTools/usr/bin/git"

    if [[ ! -e "${git_cmd_path}" ]]; then
      # Install command line developer tool
      xcode-select --install
      read -p "Press any key when the installation has completed." -n 1 -r
    else
      echo "Command line developer tools are installed."
    fi
  }

  function install_rosetta() {
    sudo softwareupdate --agree-to-license --install-rosetta
  }

  echo "Initializing MacOS..."
  install_xcode
  install_rosetta
}

function initialize_linux() {
  echo "Initializing Linux..."
}

function get_homebrew_install_dir() {
  if [[ "${ostype}" == "Darwin" ]]; then
    echo "/opt/homebrew"
  elif [[ "${ostype}" == "Linux" ]]; then
    echo "/home/linuxbrew/.linuxbrew"
  fi
}

function install_homebrew() {
  # Install Homebrew if necessary
  export HOMEBREW_CASK_OPTS=--no-quarantine
  if [[ -e "$(get_homebrew_install_dir)/bin/brew" ]]; then
    echo "Homebrew is already installed."
  else
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
}

function install_chezmoi() {
  # Install chezmoi if necessary
  if [[ -e "$(get_homebrew_install_dir)/bin/chezmoi" ]]; then
    echo "Chezmoi is already installed."
  else
    brew install chezmoi
  fi
}

function install_1password() {
  # Install 1Password if necessary
  if [[ "${ostype}" == "Darwin" ]]; then
    if [[ -e "$(get_homebrew_install_dir)/bin/op" ]]; then
      echo "1Password is already installed."
    else
      brew install --cask 1password
      brew install --cask 1password-cli
    fi
  elif [[ "${ostype}" == "Linux" ]]; then
    if [[ -e "/usr/local/bin/op" ]]; then
      echo "1Password is already installed."
    else
      brew install unzip
      if [[ "${arch}" == "aarch64" ]]; then
        wget "https://cache.agilebits.com/dist/1P/op2/pkg/v2.32.0/op_linux_arm64_v2.32.0.zip" -O op.zip && \
        unzip -d op op.zip && \
        sudo mv op/op /usr/local/bin/ && \
        rm -r op.zip op && \
        sudo groupadd -f onepassword-cli && \
        sudo chgrp onepassword-cli /usr/local/bin/op && \
        sudo chmod g+s /usr/local/bin/op
      else
        wget "https://cache.agilebits.com/dist/1P/op2/pkg/v2.32.0/op_linux_amd64_v2.32.0.zip" -O op.zip && \
        unzip -d op op.zip && \
        sudo mv op/op /usr/local/bin/ && \
        rm -r op.zip op && \
        sudo groupadd -f onepassword-cli && \
        sudo chgrp onepassword-cli /usr/local/bin/op && \
        sudo chmod g+s /usr/local/bin/op
      fi
    fi
  fi
  read -p "Please open 1Password, log into all accounts and set under Settings>CLI activate Integrate with 1Password CLI. Press any key to continue." -n 1 -r
}

function get_homebrew_shellenv() {
  $(get_homebrew_install_dir)/bin/brew shellenv
}

initialize_os_env
install_homebrew
eval "$(get_homebrew_shellenv)"
install_chezmoi
install_1password

# Apply dotfiles
echo "Applying Chezmoi configuration."
chezmoi init "${DOTFILES_REPO_URL}"
cd ~/.local/share/chezmoi
git remote set-url origin git@github.com:vdhict/dotfiles.git
chezmoi apply
