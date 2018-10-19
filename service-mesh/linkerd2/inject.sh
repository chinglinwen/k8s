kubectl get -n emojivoto deploy -o yaml \
  | linkerd inject --registry harbor.wk.qianbao-inc.com/linkerd - \
  | kubectl apply -f -
