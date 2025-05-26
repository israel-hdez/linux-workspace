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

if [ ! -e $HOME/.local/bin/kubebuilder ]; then
  kubebuilder_to_install=$(curl https://api.github.com/repos/kubernetes-sigs/kubebuilder/releases/latest | jq -r '.tag_name')
  curl -L -o $HOME/.local/bin/kubebuilder-$kubebuilder_to_install "https://go.kubebuilder.io/dl/latest/$(go env GOOS)/$(go env GOARCH)"
  chmod +x $HOME/.local/bin/kubebuilder-$kubebuilder_to_install
  rm -f $HOME/.local/bin/kubebuilder
  ln -s $HOME/.local/bin/kubebuilder-$kubebuilder_to_install $HOME/.local/bin/kubebuilder
fi

# Install Python tools
sudo dnf install -y pipx
pipx ensurepath
if ! command -v poetry &> /dev/null; then
  #echo "Installing Poetry" 
  pipx install poetry

  # NOTE: KServe uses a modified version of the poetry-version-plugin, which should be
  # injected to poetry by running this command inside the KServe source code:
  #     $ pipx inject poetry -e python/plugin/poetry-version-plugin
  # The official one would be installed with:
  #     $ poetry self add poetry-version-plugin
fi
# From kserve scripts:
poetry config virtualenvs.create true
poetry config virtualenvs.in-project true
poetry config installer.parallel true

if ! command -v pyenv &> /dev/null; then
  # pyenv - based on pyenv-installer script
  # TODO: Find a way to install latest version/tag of pyenv
  # TODO: Install some predefined versions I use????
  sudo dnf install -y dnf-plugins-core
  sudo dnf builddep -y python3
  git -c advice.detachedHead=0 clone --branch v2.3.36 --depth 1 https://github.com/pyenv/pyenv.git $HOME/apps/pyenv
  git -c advice.detachedHead=0 clone --branch master --depth 1 https://github.com/pyenv/pyenv-update.git $HOME/apps/pyenv/plugins/pyenv-update
  git -c advice.detachedHead=0 clone --branch master --depth 1 https://github.com/pyenv/pyenv-virtualenv.git $HOME/apps/pyenv/plugins/pyenv-virtualenv
fi

# Install minio cli
# NOTE: the minio ´mc´ command shadows the Midnight Commander. I don't use MC,
#   so this is OK for me, for the time being.
if [ ! -e $HOME/.local/bin/mc ]; then
  curl -o $HOME/.local/bin/mc https://dl.min.io/client/mc/release/linux-amd64/mc
  chmod +x $HOME/.local/bin/mc
fi

# Java related
sudo dnf install maven # Note: in Fedora, this also installs jdk and makes javac available.
