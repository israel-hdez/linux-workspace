#!/bin/bash

set -x

#sudo dnf install gitk

# Install yq
if [ ! -e $HOME/.local/bin/yq ]; then
  yq_version_to_install=$(curl -s https://api.github.com/repos/mikefarah/yq/releases/latest | \
    grep "tag_name" | \
    sed -e 's/.*://' -e 's/ *"//' -e 's/",//')
  if [ -z "${yq_version_to_install}" ]; then
    echo "ERROR: Cannot determine yq version to install"
  fi

  curl -sL https://github.com/mikefarah/yq/releases/download/$yq_version_to_install/yq_linux_amd64 -o $HOME/.local/bin/yq
  chmod +x $HOME/.local/bin/yq
fi

# Install grpcurl and gitk
sudo dnf install -y grpcurl gitk

# Install Snyk CLI
if [ ! -e $HOME/.local/bin/snyk ]; then
  snyk_to_install=$(curl https://api.github.com/repos/snyk/cli/releases | \
    grep "tag_name" | \
    sed -e 's/.*://' -e 's/ *"//' -e 's/",//' | \
    sort -t "." -k 1.2g,1 -k 2g,2 -k 3g | \
    tail -n 1)
  curl -L https://github.com/snyk/cli/releases/download/$snyk_to_install/snyk-linux -o $HOME/.local/bin/snyk
  chmod +x $HOME/.local/bin/snyk
fi

# Install Python tools
## Poetry
#curl -sSL https://install.python-poetry.org | python3 -

# From kserve scripts:
#poetry config virtualenvs.create true
#poetry config virtualenvs.in-project true
#poetry config installer.parallel true
#echo "Installing Poetry Version Plugin" 
#pip install -e python/plugin/poetry-version-plugin
## poetry self add poetry-version-plugin -- Need KServe version

## pyenv - based on pyenv-installer script
#sudo dnf install -y dnf-plugins-core
#sudo dnf builddep -y python3
#git -c advice.detachedHead=0 clone --branch v2.3.32 --depth 1 https://github.com/pyenv/pyenv.git $HOME/apps/pyenv
#git -c advice.detachedHead=0 clone --branch master --depth 1 https://github.com/pyenv/pyenv-update.git $HOME/apps/pyenv/plugins/pyenv-update
