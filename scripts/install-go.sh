#!/bin/bash

set -x

DL_VERSION=$(curl -s 'https://go.dev/dl/?mode=json' | jq -r '.[0].version')
INSTALL_DIR=$HOME/apps/$DL_VERSION

if [ ! -d "$INSTALL_DIR" ]; then
  mkdir -p $INSTALL_DIR
  curl -L "https://golang.org/dl/$DL_VERSION.linux-amd64.tar.gz" | tar -C $INSTALL_DIR -zx --strip-components=1
  ln -s $INSTALL_DIR $HOME/apps/go
  mkdir -p $HOME/Projects/go
fi
