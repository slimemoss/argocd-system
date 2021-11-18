# trouble shooting

## gitlab-sidekiq webservice Podが CrushLoopBackOff

### 原因: `job gitlab-migrations`が失敗している
`job`を削除したあと、`helmfile sync`を実行し、`job`を再実行します。
