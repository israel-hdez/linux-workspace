#!/bin/bash

SCRIPT=$(realpath $0)
PROJECT=$(realpath $(dirname $SCRIPT)/../)

# Download repository dependencies
(cd $PROJECT; git submodule init; git submodule update)

# Setup vim
if [ ! -e $HOME/.vim ]; then
  ln -s $PROJECT/vim $HOME/.vim
fi

# Preferred global git configs
if [ ! -e $HOME/.gitconfig ]; then
  ln -s $PROJECT/gitconfig $HOME/.gitconfig
fi

# Preferred tmux configs
if [ ! -e $HOME/.tmux.conf ]; then
  ln -s $PROJECT/tmux.conf $HOME/.tmux.conf
fi

# Preferred zsh configs
if [ ! -e $HOME/.zshrc ]; then
  ln -s $PROJECT/zshrc $HOME/.zshrc
fi
