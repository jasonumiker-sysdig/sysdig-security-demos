#!/bin/bash

# You can reset things back to defaults by deleting the VM and then let the script recreate
multipass delete microk8s-vm-sysdig
multipass purge

# Provision your local cluster VM
multipass launch --cpus 4 --mem 8G --disk 20G --name microk8s-vm-sysdig 22.04

# Deploy and run setup-microk8s.sh to our new VM
multipass transfer ./bootstrap-microk8s-vm.sh microk8s-vm-sysdig:/home/ubuntu/
multipass transfer ./sysdig-agent-helm-install.sh microk8s-vm-sysdig:/home/ubuntu/
multipass exec microk8s-vm-sysdig -- chmod +x /home/ubuntu/bootstrap-microk8s-vm.sh
multipass exec microk8s-vm-sysdig -- chmod +x /home/ubuntu/sysdig-agent-helm-install.sh
multipass exec microk8s-vm-sysdig -- /home/ubuntu/bootstrap-microk8s-vm.sh

# Copy the .kube/config to the local machine
multipass transfer microk8s-vm-sysdig:/home/ubuntu/.kube/config ~/.kube/config