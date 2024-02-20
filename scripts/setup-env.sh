#!/bin/bash

set -ux

### OS detection
DISTRO="unknown"

if [ -f /etc/os-release ]; then
  grep '^NAME=.\?Fedora' /etc/os-release -q
  if [ $? -eq 0 ]; then DISTRO="fedora"; fi


  if [ "$DISTRO" == "unknown" ]; then
    grep '^ID_LIKE=.\?fedora' /etc/os-release -q
    if [ $? -eq 0 ]; then DISTRO="fedora"; fi
  fi

  grep '^NAME=.\?Ubuntu' /etc/os-release -q
  if [ $? -eq 0 ]; then DISTRO="ubuntu"; fi
fi

export DISTRO

### Helper functions
pkg_install() {
  local cmd

  if [ "$DISTRO" == "fedora" ]; then
    cmd="sudo dnf install -y --setopt=install_weak_deps=False"
  else
    echo "Script is not compatible yet with distro: $DISTRO"
    exit 1
  fi

  $cmd $@
}

### Check how we are being run
SCRIPT=$(realpath $0)
PROJECT=$(realpath $(dirname $SCRIPT)/../)

if [ "$DISTRO" == "unknown" ]; then
  echo "Cannot properly setup the environment: unknown distribution."
  exit 1
fi

if [ "$HOME/Projects/linux-workspace" != "$PROJECT" ]; then
  # If this script is not ran from the preferred projects path, assume it was
  # ran by downloading with `curl` and piping to bash. It is not possible to
  # continue on that state. So, clone the git repo and re-run from the
  # downloaded sources.

  pkg_install git git-crypt
  mkdir -p $HOME/Projects
  $(cd $HOME/Projects; git clone https://github.com/israel-hdez/linux-workspace.git)

  $HOME/Projects/linux-workspace/scripts/setup-env.sh
  exit $?
fi

# Make sure that submodules are present
(cd $PROJECT; git submodule init; git submodule update)

### Create the preferred $HOME paths and install preferred tools
. $PROJECT/scripts/create-home-hierarchy.sh

pkg_install htop tmux xfce4-terminal zsh vim-enhanced vim-X11
if [ "$DISTRO" == "fedora" ]; then
  sudo dnf groupinstall -y --setopt=install_weak_deps=False "Development Tools"
fi

$PROJECT/scripts/install-direnv.sh
$PROJECT/scripts/install-go.sh
$PROJECT/scripts/install-nvm.sh
$PROJECT/scripts/install-container-tools.sh
$PROJECT/scripts/install-desktop-apps.sh
$PROJECT/scripts/install-dev-tools.sh

### Install configurations
# TODO: Show status of symlinks

# vim configs
if [ ! -e $HOME/.vim ]; then
  ln -s $PROJECT/vim $HOME/.vim
fi

# Global git configs
if [ ! -e $HOME/.gitconfig ]; then
  ln -s $PROJECT/gitconfig $HOME/.gitconfig
fi

# tmux configs
if [ ! -e $HOME/.tmux.conf ]; then
  ln -s $PROJECT/tmux.conf $HOME/.tmux.conf
fi

# zsh configs
if [ ! -e $HOME/.zshrc ]; then
  ln -s $PROJECT/zshrc $HOME/.zshrc
fi

# XFCE4 Terminal configs
if [ ! -e $HOME/.config/xfce4/terminal/terminalrc ]; then
  mkdir -p $HOME/.config/xfce4/terminal/
  ln -s $PROJECT/xfce4rc $HOME/.config/xfce4/terminal/terminalrc
fi

# ssh config
$PROJECT/scripts/setup-ssh.sh

### Finish setup

# If we are not in zsh, start a new (preferred) terminal. It should start
# with tmux+zsh, which is the preferred setup.
if [[ "$SHELL" != *"zsh"* ]]; then
  # TODO: Migrate to Xfconf: Your Terminal settings have been migrated to Xfconf. The config file terminalrc is not used anymore.
  # TODO: The following comand can block the terminal
  xfce4-terminal
fi

# TODO: Setup GPG - reset - sudo service pcscd restart
# TODO: Setup password store
