#!/bin/bash

# Get etcd status of scoped k8s cluster from kubeconfig
# Environment, DomainName, FQDN, ETCD cluster is getting pulled from
# scoped cluster, using sed and jsonpath

#Get k8s cluster name
CLUSTER_NAME=`(kubectl config view -o jsonpath='{.clusters[0].name}')`

#Get k8s cluster fqdn
CLUSTER_FQDN=`(kubectl config view -o jsonpath='{.clusters[0].cluster.server}')`

#Get k8s master-0 ExternalIP
MASTER0=`(kubectl get nodes -l node-role.kubernetes.io/master -o jsonpath='{.items[0].status.addresses[?(@.type=="ExternalIP")].address}')`

#Get k8s all masters ExternalIP
MASTER_NODES=`(kubectl get nodes -l node-role.kubernetes.io/master -o jsonpath='{.items[*].status.addresses[?(@.type=="ExternalIP")].address}')`

# Get Master/Workers nodes hostnames
NODES_HOSTNAME=`(kubectl get nodes -o jsonpath='{.items[*].status.addresses[?(@.type=="Hostname")].address}')`

# Get Master/Workers nodes InternalIP's
NODES_INT_IPS=`(kubectl get nodes -o jsonpath='{.items[*].status.addresses[?(@.type=="InternalIP")].address}')`

# Get Masters/Workers, a range of Hostnames and Internal IPS sparated by space
NODES=`(kubectl get nodes -o jsonpath='{range .items[*]}{.status.addresses[?(@.type=="Hostname")].address}{"\t"}{.status.addresses[?(@.type=="InternalIP")].address}{"\n"}{end}')`

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

# Output
echo "Checking etcd status for cluster:" $CLUSTER_NAME
echo "Following etcd servers were found:" $ETCD_SERVERS
echo "Kubernetes master IP's:" $MASTER_NODES
echo "ETCD Cluster Health:"
# Get on master0 and run etcdctl, this should be a function to execute an specific param given by the user
# e.g member-list, and even ntpq or others quick checks we normally do, ES shards, etc.
ssh -i /data/id_rsa_core -q -o StrictHostKeyChecking=no core@$MASTER0 "etcdctl --cert-file=$CRT_F --key-file=$KEY_F --ca-file=$CAA_F --endpoints $ETCD_SERVERS cluster-health"



