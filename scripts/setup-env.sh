#!/bin/bash

SCRIPT=$(realpath $0)
PROJECT=$(realpath $(dirname $SCRIPT)/../)

# Download repository dependencies
(cd $PROJECT; git submodule init; git submodule update)

# Setup vim
if [ ! -e $HOME/.vim ]; then
  ln -s $PROJECT/vim $HOME/.vim
fi
