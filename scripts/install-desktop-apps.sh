#!/bin/bash
#

set -x

if [ "$DISTRO" == "fedora" ]; then
  sudo dnf install -y remmina
  sudo dnf install -y --setopt=install_weak_deps=False pass 
fi

