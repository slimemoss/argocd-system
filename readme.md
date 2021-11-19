# argocd-system
x8sのリソースの中で、インフラ・システム寄りのものを管理するargocdリポジトリ

# セットアップ
## argocdを有効にするための準備
argocdをオンプレで使うために、各リソースをデプロイします。

### デプロイ
```
kustomize build cert-manager | k apply -f -
kustomize build ingress-nginx | k apply -f -
kustomize build metallb | k apply -f -
kustomize build rook | k apply -f -
```

### シークレットのデプロイ

* `metallb`: `secretkey`
* `cert-manager`: `api-token`

```
k apply -f ../argocd-system-secret/argocd-config/cert-manager.yaml
k apply -f ../argocd-system-secret/argocd-config/metallb.yaml
```

### テスト
```
k apply -f ./test/ingress-test.yaml
curl https://ingress-test.slimemoss.com
openssl s_client -connect ingress-test.slimemoss.com:443 -showcerts < /dev/null 2> /dev/null | openssl x509 -noout -subject -in -
```

## 手動デプロイ
### argocdのデプロイ
```
kustomize build argocd | k apply -f -
```

### gitlab-runnerのデプロイ
```
cd ./gitlab-runner/helm
helmfile sync
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
外部からのアクセスを`metallb/configmap.yaml data.config.address-pools[0].addresses[0]`に渡すよう、ルータのポート設定を行う
