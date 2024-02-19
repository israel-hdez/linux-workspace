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

  # Install VBox
  dnf repolist | grep -q VirtualBox
  if [ $? -ne 0 ]; then
    sudo dnf config-manager --add-repo https://download.virtualbox.org/virtualbox/rpm/fedora/virtualbox.repo
    sudo dnf install -y kernel-devel # Install in a separate step, to ensure vbox is configured correctly
    sudo dnf install -y VirtualBox-7.0
  fi

  # Install minikube
  if [ ! -e $HOME/.local/bin/minikube ]; then
    curl -L https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 -o $HOME/.local/bin/minikube
    chmod u+x $HOME/.local/bin/minikube
  fi

  # Install kubectl
  if [ ! -e $HOME/.local/bin/kubectl ]; then
    curl -L "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" -o $HOME/.local/bin/kubectl
    kubectl_checksum=$(curl -L "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256")
    echo "$kubectl_checksum  $HOME/.local/bin/kubectl" | sha256sum --check
    if [ $? -eq 0 ]; then
      chmod u+x $HOME/.local/bin/kubectl
    fi
  fi

  # Install kubectl
  if [ ! -e $HOME/.local/bin/k9s ]; then
    k9s_version_to_install=$(curl https://api.github.com/repos/derailed/k9s/releases | \
      grep "tag_name" | \
      sed -e 's/.*://' -e 's/ *"//' -e 's/",//' | \
      sort -t "." -k 1.2g,1 -k 2g,2 -k 3g | \
      tail -n 1)
    if [ -z "${k9s_version_to_install}" ]; then
      echo "ERROR: Cannot determine k9s version to install"
    fi

    curl -L https://github.com/derailed/k9s/releases/download/$k9s_version_to_install/k9s_Linux_x86_64.tar.gz | \
      tar -C $HOME/.local/bin -zx k9s
    #chmod u+x $HOME/.local/bin/k9s
  fi
fi

