# argocd-system
s8sのリソースの中で、インフラ・システム寄りのものを管理するargocdリポジトリ

# セットアップ
## argocdのインストール
```
kustomize build . | k apply -f -
```

## Applicationの登録

1. web guiにアクセス

```
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

[web gui](localhost:8080)

ユーザーは`admin` パスワードは`kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath={.data.password} | base64 -d | xsel --clipboard --input`


2. Applicationを登録

web guiから`argocd-config.yaml`を登録する

# 手動なこと
## ルータのポート転送設定
外部からのアクセスを`192.168.2.250`に渡すよう、ルータのポート設定を行う
