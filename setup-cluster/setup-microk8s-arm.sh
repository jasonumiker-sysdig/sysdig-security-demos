#!/bin/bash
# NOTE: Run this with sudo

# Install microk8s on it
snap install microk8s --channel=1.24/stable --classic

# Enable CoreDNS, RBAC, hostpath-storage, ingress
microk8s enable dns rbac hostpath-storage ingress
microk8s status --wait-ready

# Install kubectl in microk8s-vm
snap install kubectl --classic

# Install helm in microk8s-vm
snap install helm --classic

# Install crictl in microk8s-vm
wget -q https://github.com/kubernetes-sigs/cri-tools/releases/download/v1.24.1/crictl-v1.24.1-linux-arm64.tar.gz
tar zxvf crictl-v1.24.1-linux-arm64.tar.gz -C /usr/local/bin
rm -f crictl-v1.24.1-linux-arm64.tar.gz
echo "runtime-endpoint: unix:///var/snap/microk8s/common/run/containerd.sock" > /etc/crictl.yaml

# Set up the kubeconfig
mkdir /root/.kube
microk8s.config | cat - > /root/.kube/config

# Install the Sysdig Agent
/home/ubuntu/sysdig-agent-helm-install.sh

# Set up multi-tenancy
# Create token for Jane to access team1
JANE_TOKEN=$(openssl rand -base64 32 | base64)
echo $JANE_TOKEN > jane.token

# Create token for John to access team2
JOHN_TOKEN=$(openssl rand -base64 32 | base64)
echo $JOHN_TOKEN > john.token

# Append our new tokens to the file
echo $JANE_TOKEN",jane,jane" > ./known_tokens.csv
echo $JOHN_TOKEN",john,john" >> ./known_tokens.csv

# Add the new kubeconfig contexts for Jane and John
kubectl config set-context microk8s-jane --cluster=microk8s-cluster --namespace=team1 --user=jane
kubectl config set-context microk8s-john --cluster=microk8s-cluster --namespace=team2 --user=john
echo "- name: jane" >> /root/.kube/config
echo "  user:" >> /root/.kube/config
echo "    token: "$JANE_TOKEN >> /root/.kube/config
echo "- name: john" >> /root/.kube/config
echo "  user:" >> /root/.kube/config
echo "    token: "$JOHN_TOKEN >> /root/.kube/config
cat known_tokens.csv >> /var/snap/microk8s/current/credentials/known_tokens.csv
microk8s stop
microk8s start
mkdir /home/ubuntu/.kube/
cp /root/.kube/config /home/ubuntu/.kube/config
chown ubuntu:ubuntu -R /home/ubuntu/.kube