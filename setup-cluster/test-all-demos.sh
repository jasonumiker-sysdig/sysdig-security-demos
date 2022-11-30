#!/bin/bash
# This script will run through all the demos to both test that they work as
# well as to trigger all of the associated Events in Falco

kubectl get pods -A
echo "--------------------"
cd ~/sysdig-security-demos
cat team1.yaml
echo "--------------------"
kubectl api-resources
echo "--------------------"
kubectl get clusterrole admin -o yaml
echo "--------------------"
kubectl get clusterrole admin -o yaml | wc -l
echo "--------------------"
kubectl apply -f team1.yaml && kubectl apply -f team2.yaml
echo "--------------------"
kubectl config get-contexts
echo "--------------------"
kubectl config use-context microk8s-jane
echo "--------------------"
kubectl get pods -A
echo "--------------------"
kubectl get pods
echo "--------------------"
cd ~/sysdig-security-demos/demos/network-policy/hello-app
kubectl apply -f .
echo "--------------------"
kubectl get pods
echo "--------------------"
kubectl describe deployments hello-client-allowed
echo "--------------------"
kubectl config use-context microk8s-john
echo "--------------------"
kubectl get pods
echo "--------------------"
kubectl get pods --namespace=team1
echo "--------------------"
kubectl config get-contexts
echo "--------------------"
kubectl describe secret hello-secret -n team1
echo "--------------------"
cd ~/sysdig-security-demos/demos
cat nsenter-node.sh
echo "--------------------"
echo 'Copy and paste this into the terminal below:'
echo 'ps aux'
echo 'crictl ps'
echo 'crictl ps | grep hello-client-allowed'
echo 'export HELLO_CLIENT_CONTAINER_ID=$(crictl ps | grep hello-client-allowed | awk '\''NR==1{print $1}'\'')'
echo 'crictl exec -it $HELLO_CLIENT_CONTAINER_ID /bin/sh'
echo 'set | grep API_KEY'
echo 'exit'
echo 'crictl stop $HELLO_CLIENT_CONTAINER_ID && crictl rm $HELLO_CLIENT_CONTAINER_ID'
echo 'exit'
./nsenter-node.sh
echo "--------------------"
cd ~/sysdig-security-demos/demos/security-playground
cat app.py
echo "--------------------"
cat example-curls.sh
echo "--------------------"
kubectl config use-context microk8s
echo "--------------------"
kubectl apply -f security-playground.yaml
sleep 60
echo "--------------------"
kubectl get pods -n security-playground
echo "--------------------"
./example-curls.sh
echo "--------------------"
cd ~/sysdig-security-demos/opa-gatekeeper
cat ./install-gatekeeper.sh
echo "--------------------"
./install-gatekeeper.sh
echo "--------------------"
cd ~/sysdig-security-demos/demos
./nsenter-node.sh
echo "--------------------"
cd ~/sysdig-security-demos/opa-gatekeeper/policies/constraint-templates/
cd ~/sysdig-security-demos/opa-gatekeeper/policies/constraints
cd ~/sysdig-security-demos/opa-gatekeeper
./uninstall-gatekeeper.sh
echo "--------------------"
cd ~/sysdig-security-demos/demos/security-playground
kubectl logs deployment/hello-client-allowed -n team1
echo "--------------------"
kubectl logs deployment/hello-client-blocked -n team1
echo "--------------------"
cd ~/sysdig-security-demos/demos/network-policy/hello-app
kubectl apply -f  hello-client.yaml -n team2
echo "--------------------"
kubectl logs deployment/hello-client-allowed -n team2
echo "--------------------"
kubectl logs deployment/hello-client-blocked -n team2
echo "--------------------"
cd ~/sysdig-security-demos/demos/network-policy
cat network-policy-namespace.yaml
echo "--------------------"
kubectl apply -f network-policy-namespace.yaml -n team1
echo "--------------------"
kubectl logs deployment/hello-client-allowed -n team1
echo "--------------------"
kubectl logs deployment/hello-client-blocked -n team1
echo "--------------------"
cd ~/sysdig-security-demos/demos/network-policy/hello-app
kubectl logs deployment/hello-client-allowed -n team2
echo "--------------------"
kubectl logs deployment/hello-client-blocked -n team2
echo "--------------------"
cd ~/sysdig-security-demos/demos/network-policy
cat network-policy-label.yaml
echo "--------------------"
kubectl apply -f network-policy-label.yaml -n team1
echo "--------------------"
kubectl logs deployment/hello-client-blocked -n team1
echo "--------------------"
kubectl logs deployment/hello-client-blocked -n team2
echo "--------------------"
kubectl logs deployment/hello-client-allowed -n team2
echo "--------------------"
cat network-policy-label-all-namespaces.yaml
echo "--------------------"
kubectl apply -f network-policy-label-all-namespaces.yaml -n team1
echo "--------------------"
kubectl logs deployment/hello-client-allowed -n team2
echo "--------------------"