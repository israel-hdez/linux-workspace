#!/bin/bash

if [ -z "$HOME" ]; then
  echo '$HOME is undefined'
  exit 1
fi

[ -d "$HOME/.local/bin" ] || mkdir -p $HOME/.local/bin
[ -d "$HOME/apps" ] || mkdir $HOME/apps
[ -d "$HOME/Projects" ] || mkdir $HOME/Projects
