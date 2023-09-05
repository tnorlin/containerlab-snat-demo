# Demo of kubernetes environment with conntrackd and keepalived 

Trying out the containerlab and its capabilities with the goal of implementing
a HA outgoing IP through conntrackd and keepalived.

## Note 
Current state: only the base cluster installed, two BGP peers, switch and 
connectivity between the nodes. Keepalived and conntrackd installed. No 
outgoing connectivity implemented, yet.

## Installation
Install Containerlab according to https://containerlab.dev/install/

## Stand up kubernetes
kind create cluster --config cluster.yaml

## Deploy the environment
sudo -E containerlab deploy -t clab-k8s-conntrack-bgp.yml 


## TODO: Install Cilium, stand up the other side's another cluster (and BGP 
peers), implement netfilter rules, connect with other cluster.
