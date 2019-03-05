#!/bin/bash

KVM_READY=$(egrep -c '(vmx|svm)' /proc/cpuinfo)

if [ "$KVM_READY" == "0" ]; then
  echo "CPU doesn't support hardware virtualization. KVM not installed."
  exit 0
fi

apt-get install -y qemu-kvm libvirt-bin ubuntu-vm-builder bridge-utils virt-manager
adduser $(logname) libvirt
adduser $(logname) libvirt-qemu
