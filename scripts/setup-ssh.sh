#!/bin/bash

set -ux

PROJECT=$(realpath $(dirname $SCRIPT)/../)

# Create main Ed25519 key
if [ ! -e $HOME/.ssh/id_ed25519 ]; then
  ssh-keygen -t ed25519 -N "" -C "$(hostname)" -f $HOME/.ssh/id_ed25519
fi

# Mirror the main Ed25519 key as a GitHub specific key
if [ ! -e $HOME/.ssh/github_israel_hdez ]; then
  ln -s $HOME/.ssh/id_ed25519 $HOME/.ssh/github_israel_hdez
  ln -s $HOME/.ssh/id_ed25519.pub $HOME/.ssh/github_israel_hdez.pub
fi

# Create secondary Ed25519 key for a secondary GitHub account
if [ ! -e $HOME/.ssh/github_edgarHzg ]; then
  ssh-keygen -t ed25519 -N "" -C "$(hostname)" -f $HOME/.ssh/github_edgarHzg
fi

# ssh config
if [ ! -e $HOME/.ssh/config ]; then
  mkdir -p $HOME/.ssh
  ln -s $PROJECT/ssh/config $HOME/.ssh/config
  chmod 600 $PROJECT/ssh/config
fi

# TODO: Automate registering these keys on GitHub.
