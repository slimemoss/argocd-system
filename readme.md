# argocd-system
s8sのリソースの中で、インフラ・システム寄りのものを管理するargocdリポジトリ

# セットアップ
## argocdのインストール
```
kubectl create namespace argocd
curl https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml | sed "s@quay.io/argoproj/argocd@alinbalutoiu/argocd@g" | kubectl apply -n argocd -f -
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

# Secretの追加
Secretはリポジトリに登録できないので、sealed-secretsを使います

例) namespace`namespace-a`に`secret-a`という名前で、`key-a=value-a`というデータのsecretを登録するSealedSecretのmanifestを作成する
```
kubectl -n namespace-a create secret generic secret-a \
  --from-literal=key-a=value-a \
  --dry-run=client \
  -o yaml | \
  kubeseal --controller-namespace sealed-secrets --format=yaml
```

# 手動なこと
## ルータのポート転送設定
外部からのアクセスを`192.168.2.250`に渡すよう、ルータのポート設定を行う

## dns01 solversで使うcloudflareのapi tokenのsecretを変更した場合
```
read -s | xargs -I@ kubectl create secret generic -n cert-manager cloudflare-api-token-secret --from-literal=api-token=@ --dry-run=client -o yaml | kubeseal --controller-namespace sealed-secrets --format=yaml > cert-manager/cloudflare-api-token.yaml
```
