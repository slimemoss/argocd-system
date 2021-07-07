# argocd-system
s8sのリソースの中で、インフラ・システム寄りのものを管理するargocdリポジトリ

# セットアップ
## rookのデプロイ
```
cd ./rook
kustomize build . | k apply -f -
```

## gitlab-runnerのデプロイ
```
cd ./gitlab-runner
helmfile sync
```

## argocdのインストール
```
cd ./argocd
kustomize build . | k apply -f -
```

## Applicationの登録
### argocdへのログイン
```
argocd --port-forward --port-forward-namespace argocd \
login localhost:8080 --name admin --username admin --password (kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath={.data.password} | base64 -d)
```

### private repositoryの認証
```
read -s | xargs -I@ argocd --port-forward --port-forward-namespace argocd \
repo add https://github.com/slimemoss/argocd-system.git --username slimemoss --password @
```

### デプロイ
```
argocd --port-forward --port-forward-namespace argocd \
app create -f argocd-config.yaml
```

# 手動なこと
## ルータのポート転送設定
外部からのアクセスを`192.168.2.250`に渡すよう、ルータのポート設定を行う
