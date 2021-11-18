# Rook

## upgrade
### 1.5.12 -> 1.6.10
```
kubectl apply -f https://raw.githubusercontent.com/rook/rook/v1.6.10/cluster/examples/kubernetes/ceph/common.yaml
kubectl apply -f https://raw.githubusercontent.com/rook/rook/v1.6.10/cluster/examples/kubernetes/ceph/crds.yaml
kubectl apply -f https://raw.githubusercontent.com/rook/rook/v1.6.10/cluster/examples/kubernetes/ceph/monitoring/rbac.yaml
kubectl -n rook-ceph patch cephcluster/rook-ceph -p '{"spec":{"monitoring":{"enabled":false}}}'
kubectl -n rook-ceph set image deploy/rook-ceph-operator rook-ceph-operator=rook/ceph:v1.6.10
```

```
set ROOK_CLUSTER_NAMESPACE rook-ceph
watch --exec kubectl -n $ROOK_CLUSTER_NAMESPACE get deployments -l rook_cluster=$ROOK_CLUSTER_NAMESPACE -o jsonpath='{range .items[*]}{.metadata.name}{"  \treq/upd/avl: "}{.spec.replicas}{"/"}{.status.updatedReplicas}{"/"}{.status.readyReplicas}{"  \trook-version="}{.metadata.labels.rook-version}{"\n"}{end}'
```

### 1.6.10 -> 1.7.7
```
kubectl apply -f https://raw.githubusercontent.com/rook/rook/v1.7.7/cluster/examples/kubernetes/ceph/common.yaml
kubectl apply -f https://raw.githubusercontent.com/rook/rook/v1.7.7/cluster/examples/kubernetes/ceph/crds.yaml
kubectl apply -f https://raw.githubusercontent.com/rook/rook/v1.7.7/cluster/examples/kubernetes/ceph/monitoring/rbac.yaml
kubectl -n rook-ceph set image deploy/rook-ceph-operator rook-ceph-operator=rook/ceph:v1.7.7
```

```
set ROOK_CLUSTER_NAMESPACE rook-ceph
watch --exec kubectl -n $ROOK_CLUSTER_NAMESPACE get deployments -l rook_cluster=$ROOK_CLUSTER_NAMESPACE -o jsonpath='{range .items[*]}{.metadata.name}{"  \treq/upd/avl: "}{.spec.replicas}{"/"}{.status.updatedReplicas}{"/"}{.status.readyReplicas}{"  \trook-version="}{.metadata.labels.rook-version}{"\n"}{end}'
```

## ディスクのクリーンアップ
```
kustomize build . | k delete -f -
```

## リソースが削除できないとき
```
kubectl api-resources --verbs=list --namespaced -o name | xargs -n 1 kubectl get --show-kind --ignore-not-found -n rook-ceph
```

```
kubectl -n rook-ceph patch crd cephclusters.ceph.rook.io --type merge -p '{"metadata":{"finalizers": [null]}}'
kubectl -n rook-ceph patch cephblockpool replicapool --type merge -p '{"metadata":{"finalizers": [null]}}'
```
