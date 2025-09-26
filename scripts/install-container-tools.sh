#!/bin/bash

set -x

if [ "$DISTRO" == "fedora" ]; then
  # Check if docker is available in repositories

  # Install AWS CLI
  sudo dnf install awscli2

  # Install ROSA CLI
  curl https://mirror.openshift.com/pub/openshift-v4/clients/rosa/latest/rosa-linux.tar.gz | tar -C $HOME/.local/bin -xz

  # Enable container-tools module (podman)
  sudo dnf module install -y container-tools
  if [ $? -ne 0 ]; then
    # If contaner-tools module is not available. Fallback to installing podman packge
    sudo dnf install -y --setopt=install_weak_deps=False podman
  fi

  # If docker CLI is not available, create docker as an alias to podman
  if ! command -v docker &> /dev/null; then
    ln -s $(which podman) $HOME/.local/bin/docker
  fi

  # Install VBox
  dnf repolist | grep -q VirtualBox
  if [ $? -ne 0 ]; then
    sudo dnf config-manager --add-repo https://download.virtualbox.org/virtualbox/rpm/fedora/virtualbox.repo
    sudo dnf install -y kernel-devel # Install in a separate step, to ensure vbox is configured correctly
    sudo dnf install -y VirtualBox-7.0
  fi

  # Install k9s
  if [ ! -e $HOME/.local/bin/k9s ]; then
    k9s_version_to_install=$(curl https://api.github.com/repos/derailed/k9s/releases | \
      grep "tag_name" | \
      sed -e 's/.*://' -e 's/ *"//' -e 's/",//' | \
      sort -t "." -k 1.2g,1 -k 2g,2 -k 3g | \
      tail -n 1)
    if [ -z "${k9s_version_to_install}" ]; then
      echo "ERROR: Cannot determine k9s version to install"
    fi

    curl -L https://github.com/derailed/k9s/releases/download/$k9s_version_to_install/k9s_Linux_amd64.tar.gz | \
      tar -C $HOME/.local/bin -zx k9s
  fi

  # Install oc CLI
  if [ ! -e $HOME/.local/bin/oc ]; then
    curl https://mirror.openshift.com/pub/openshift-v4/clients/ocp/stable-4.13/openshift-client-linux.tar.gz | \
      tar -C $HOME/.local/bin -zx oc
  fi

  # Install operator-sdk
  # TODO
  if [ ! -e $HOME/.local/bin/operator-sdk ]; then
    operator_sdk_version_to_install=$(curl https://api.github.com/repos/operator-framework/operator-sdk/releases | \
      grep "tag_name" | \
      sed -e 's/.*://' -e 's/ *"//' -e 's/",//' | \
      sort -t "." -k 1.2g,1 -k 2g,2 -k 3g | \
      tail -n 1)
    #operator_sdk_url=https://github.com/operator-framework/operator-sdk/releases/download/$operator_sdk_version_to_install
    curl -LO $operator_sdk_url/operator-sdk_linux_amd64
    #gpg --keyserver keyserver.ubuntu.com --recv-keys 052996E2A20B5C7E
    #curl -LO ${OPERATOR_SDK_DL_URL}/checksums.txt
    #curl -LO ${OPERATOR_SDK_DL_URL}/checksums.txt.asc
    #gpg -u "Operator SDK (release) <cncf-operator-sdk@cncf.io>" --verify checksums.txt.asc
    #grep operator-sdk_${OS}_${ARCH} checksums.txt | sha256sum -c -
    #chmod +x operator-sdk_${OS}_${ARCH} && sudo mv operator-sdk_${OS}_${ARCH} /usr/local/bin/operator-sdk
  fi
fi

