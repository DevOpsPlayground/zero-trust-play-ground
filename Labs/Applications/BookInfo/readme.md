
BookInfo application
https://www.openpolicyagent.org/docs/latest/envoy-tutorial-istio/

export INGRESS_HOST=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.status.loadBalancer.ingress[0].ip}')

export INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="http2")].port}')

export SECURE_INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="https")].port}')


kubectl exec "$(kubectl get pod -l app=ratings -o jsonpath='{.items[0].metadata.name}')" -c ratings -- curl -sS productpage:9080/productpage | grep -o "<title>.*</title>"



Exercise the OPA policy
Check that alice can access /productpage BUT NOT /api/v1/products.

curl --user alice:password -i http://$SERVICE_HOST/productpage
curl --user alice:password -i http://$SERVICE_HOST/api/v1/products
Check that bob can access /productpage AND /api/v1/products.

curl --user bob:password -i http://$SERVICE_HOST/productpage
curl --user bob:password -i http://$SERVICE_HOST/api/v1/products

curl -s -I -HHost:httpbin.example.com --user bob:password -i http://$SERVICE_HOST/api/v1/products