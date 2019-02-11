[![Docker Repository on Quay](https://quay.io/repository/fmoctezuma/etcdtool/status "Docker Repository on Quay")](https://quay.io/repository/fmoctezuma/etcdtool)

### etcdtool
Basic etcd healthcheck for mk8s, (check branches, this one use etcdtool:kaasctl)

### Simple usage

docker run -v /opt/rpc-mk8s/mk8s/provider-<providername>/clusters/<clustername>:/data quay.io/fmoctezuma/etcdtool:kaasctl
Checking etcd status for cluster: kubernetes
Following etcd servers were found: https://10.0.0.15:2379,https://10.0.0.14:2379,https://10.0.0.10:2379
Kubernetes master IP's: 12.34.56.78 90.87.65.43 12.34.56.89
ETCD Cluster Health:
member 147e37ea76d85cfa is healthy: got healthy result from https://10.0.0.10:2379
member 503e0d1f76136e08 is healthy: got healthy result from https://10.0.0.14:2379
member 7b9b2cb736bf0fc5 is healthy: got healthy result from https://10.0.0.15:2379
cluster is healthy
