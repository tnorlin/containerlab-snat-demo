for i in clab clab2
do  
    CLUSTERID=1
    kind create cluster --config ${i}_cluster.yaml 
    kubectl config use-context kind-${i}-k8s
    kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/v0.7.0/config/crd/standard/gateway.networking.k8s.io_gatewayclasses.yaml
    kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/v0.7.0/config/crd/standard/gateway.networking.k8s.io_gateways.yaml
    kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/v0.7.0/config/crd/standard/gateway.networking.k8s.io_httproutes.yaml
    kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/v0.7.0/config/crd/standard/gateway.networking.k8s.io_referencegrants.yaml
    kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/v0.7.0/config/crd/experimental/gateway.networking.k8s.io_tlsroutes.yaml
    
    
    export K8S_API_PORT=$(kubectl cluster-info | head -1 |awk -F: '{print $3}')
    
    cilium install --version v1.14.2 --set cluster-id=${CLUSTERID} --set cluster-name=${i} --set k8sServiceHost=127.0.0.1    --set k8sServicePort=${K8S_API_PORT} --set bgpControlPlane.enabled=true --set bgp.announce.loadbalancerIP=true --set kubeProxyReplacement=true  --set gatewayAPI.enabled=true --set hubble.ui.enabled=true --set hubble.relay.enabled=true
    kubectl rollout status -n kube-system ds/cilium
    
    kubectl apply -f ${i}-ippool.yaml 
    kubectl apply -f ${i}-bgppolicy.yaml
    let CLUSTERID=CLUSTERID+1
done

#kind create cluster --config cluster2.yaml 
#kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/v0.7.0/config/crd/standard/gateway.networking.k8s.io_gatewayclasses.yaml
#kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/v0.7.0/config/crd/standard/gateway.networking.k8s.io_gateways.yaml
#kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/v0.7.0/config/crd/standard/gateway.networking.k8s.io_httproutes.yaml
#kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/v0.7.0/config/crd/standard/gateway.networking.k8s.io_referencegrants.yaml
#kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/v0.7.0/config/crd/experimental/gateway.networking.k8s.io_tlsroutes.yaml
