#!/bin/bash
#

set -x


if [ "$IS_FEDORA" == "1" ]; then
  # Check if direnv is available in repositories
  dnf info direnv > /dev/null
  DIRENV_REPO=$(($? == 0))

  if [ "$DIRENV_REPO" -ne "0" ]; then
    # Install direnv from repo, if possible
    sudo dnf install -y direnv
  else
    if [ ! -f $HOME/.local/bin/direnv ]; then
      download_url=$(
        curl -fL https://api.github.com/repos/direnv/direnv/releases/latest \
          | grep browser_download_url \
          | cut -d '"' -f 4 \
          | grep "direnv.linux.amd64")

      mkdir -p $HOME/.local/bin
      curl -fL $download_url -o $HOME/.local/bin/direnv
      chmod +x $HOME/.local/bin/direnv
    fi
  fi
fi
