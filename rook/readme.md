# Rook

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
