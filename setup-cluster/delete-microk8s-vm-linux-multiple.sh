#!/bin/bash

NUM_OF_VMS=8

for (( i=1; i<=$NUM_OF_VMS; i++))
do
    multipass stop microk8s-vm-sysdig-$i
    multipass delete microk8s-vm-sysdig-$i
done
multipass purge