[![Docker Repository on Quay](https://quay.io/repository/fmoctezuma/etcdtool/status "Docker Repository on Quay")](https://quay.io/repository/fmoctezuma/etcdtool)

### etcdtool
Basic etcd healthcheck for mk8s, (check branches)

### Simple usage

Move to mk8s cluster directory

```
docker run -v /Some_path/mk8s/tools/installer/clusters/<ClusterDirectory>:/data --rm quay.io/fmoctezuma/etcdtool:bash

ETCD Cluster Health:
member b980d12492b48c1c is healthy: got healthy result from https://etcd-0.cluster.com:2379
member bf308d6012fc0fb6 is healthy: got healthy result from https://etcd-1.cluster.com:2379
failed to check the health of member ccbndfg on https://etcd-2.cluster.com:2379: 
Get https://etcd-2.cluster.com:2379/health: dial tcp 10.0.0.14:2379: connect: no route to host
member c0e462f6a13d1ccc is unreachable: [https://etcd-2.cluster.com:2379] are all unreachable
cluster is degraded
```
