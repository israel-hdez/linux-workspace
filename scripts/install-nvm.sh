#!/bin/bash

set -x

if [ ! -d $HOME/apps/nvm ]; then
  REPO="nvm-sh/nvm"
  LAST_VERSION=$(curl https://api.github.com/repos/$REPO/releases | grep "tag_name" | sed -e 's/.*://' -e 's/ *"//' -e 's/",//' | sort -t "." -k 1.2g,1 -k 2g,2 -k 3g  | tail -n 1)

  $(cd $HOME/apps; git clone https://github.com/$REPO.git nvm)
  $(cd $HOME/apps/nvm; git checkout $LAST_VERSION)

  export NVM_DIR="$HOME/apps/nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

  nvm install --lts
  npm install --global yarn
fi

