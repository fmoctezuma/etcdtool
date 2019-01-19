#!/bin/bash

# Get etcd status of scoped k8s cluster from kubeconfig
# Environment, DomainName, FQDN, ETCD cluster is getting pulled from
# scoped cluster, using sed and jsonpath

#Get etcd servers via yaml and sed
#ETCD_SERVERS=`(kubectl get ds kube-apiserver -n kube-system -o yaml | grep etcd-servers|sed -e 's/'etcd-servers'=//;s/- --//;s/^ *//')`

#Get k8s master-0 IP
MASTER0=`(kubectl get nodes -l node-role.kubernetes.io/master -o jsonpath='{.items[0].status.addresses[?(@.type=="ExternalIP")].address}')`

#Get k8s masters IP
MASTER_NODES=`(kubectl get nodes -l node-role.kubernetes.io/master -o jsonpath='{.items[*].status.addresses[?(@.type=="ExternalIP")].address}')`

#Get k8s cluster name
CLUSTER_NAME=`(kubectl config view -o jsonpath='{.clusters[0].name}')`

#Get k8s cluster fqdn
CLUSTER_FQDN=`(kubectl config view -o jsonpath='{.clusters[0].cluster.server}')`

#Trying to simply things with a couple of filters (not used yet)
#JSONPATH_FILTER=`(kubectl get ds kube-apiserver -n kube-system -o=jsonpath='{.items[0]}{.spec.template.spec.containers[0].command}')`
#SED_FILTER="(tr ' ' '\n'|sed -e 's/--//')"

#Get etcd servers via jsonpath
ETCD_SERVERS=`(kubectl get ds kube-apiserver -n kube-system -o=jsonpath='{.items[0]}{.spec.template.spec.containers[0].command}'\
        |tr ' ' '\n'|grep etcd-servers|sed -e 's/'etcd-servers'=//;s/- --//;s/--//;s/^ *//')`

#Get etcd certs via jsonpath thru the kubeapi-server flags
CAA_F=`(kubectl get ds kube-apiserver -n kube-system -o=jsonpath='{.items[0]}{.spec.template.spec.containers[0].command}'\
        |tr ' ' '\n'|grep etcd-ca|sed -e 's/'etcd-cafile'=//;s/- --//;s/--//;s/^ *//')`

CRT_F=`(kubectl get ds kube-apiserver -n kube-system -o=jsonpath='{.items[0]}{.spec.template.spec.containers[0].command}'\
        |tr ' ' '\n'|grep etcd-cert|sed -e 's/'etcd-certfile'=//;s/- --//;s/--//;s/^ *//')`

KEY_F=`(kubectl get ds kube-apiserver -n kube-system -o=jsonpath='{.items[0]}{.spec.template.spec.containers[0].command}'\
        |tr ' ' '\n'|grep etcd-key|sed -e 's/'etcd-keyfile'=//;s/- --//;s/--//;s/^ *//')`

echo "Checking etcd status for cluster:" $CLUSTER_NAME
echo "Following etcd servers were found:" $ETCD_SERVERS
echo "Kubernetes master IP's:" $MASTER_NODES
echo "ETCD Cluster Health:"
ssh -i id_rsa_core -q -o StrictHostKeyChecking=no core@$MASTER0 "etcdctl --cert-file=$CRT_F --key-file=$KEY_F --ca-file=$CAA_F --endpoints $ETCD_SERVERS cluster-health"
~
