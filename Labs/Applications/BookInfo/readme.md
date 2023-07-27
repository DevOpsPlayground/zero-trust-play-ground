
BookInfo application
https://www.openpolicyagent.org/docs/latest/envoy-tutorial-istio/
https://github.com/open-policy-agent/opa-envoy-plugin/tree/main/examples/istio#example-input


export INGRESS_HOST=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.status.loadBalancer.ingress[0].ip}')

export INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="http2")].port}')

export SECURE_INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="https")].port}')

Installing the book info
  kubectl apply -f https://raw.githubusercontent.com/istio/istio/master/samples/bookinfo/platform/kube/bookinfo.yaml
  
  kubectl apply -f https://raw.githubusercontent.com/istio/istio/master/samples/bookinfo/networking/bookinfo-gateway.yaml
  kubectl -n istio-system get service istio-ingressgateway


Installing the Sleep pod
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.18/samples/sleep/sleep.yaml
export SLEEP_POD=$(kubectl get pod -l app=sleep -o jsonpath={.items..metadata.name})
kubectl exec ${SLEEP_POD} -c sleep  -- curl -i opa.trusty-panda.svc.cluster.local:9191


kubectl exec "$(kubectl get pod -l app=ratings -o jsonpath='{.items[0].metadata.name}')" -c ratings -- curl -sS productpage:9080/productpage | grep -o "<title>.*</title>"



Exercise the OPA policy
Check that alice can access /productpage BUT NOT /api/v1/products.

curl --user alice:password -i http://$SERVICE_HOST/productpage
curl --user alice:password -i http://$SERVICE_HOST/api/v1/products
Check that bob can access /productpage AND /api/v1/products.

curl --user bob:password -i http://$SERVICE_HOST/productpage
curl --user bob:password -i http://$SERVICE_HOST/api/v1/products

curl -s -I -HHost:httpbin.example.com --user bob:password -i http://$SERVICE_HOST/api/v1/products


kubectl exec "$(kubectl get pod -l app=ratings -o jsonpath='{.items[0].metadata.name}')" -c ratings -- curl -sS productpage:9080/productpage | grep -o "<title>.*</title>"


kubectl exec "$(kubectl get pod -l app=ratings -o jsonpath='{.items[0].metadata.name}')" -c productpage -- curl -sS productpage:9080/productpage --user alice:password

kubectl exec "$(kubectl get pod -l app=ratings -o jsonpath='{.items[0].metadata.name}')" -c ratings -- curl -sS productpage:9080/productpage --user alice:password


        - /policies/policy.rego

Testing sleep POST

kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.18/samples/sleep/sleep.yaml
kubectl exec ${SLEEP_POD} -c sleep  -- curl -i opa.funny-panda.svc.cluster.local:9191


Test 1
kubectl exec "$(kubectl get pod -l app=ratings -o jsonpath='{.items[0].metadata.name}')" -c ratings -- curl -sS productpage:9080/productpage | grep -o "<title>.*</title>"

API Test
kubectl exec "$(kubectl get pod -l app=ratings -o jsonpath='{.items[0].metadata.name}')" -c ratings -- curl -sS productpage:9080/api/v1/products

kubectl exec "$(kubectl get pod -l app=ratings -o jsonpath='{.items[0].metadata.name}')" -c ratings -- curl -sS productpage:9080/productpage --user alice:password
kubectl exec "$(kubectl get pod -l app=ratings -o jsonpath='{.items[0].metadata.name}')" -c ratings -- curl -sS productpage:9080/productpage

Testing
kubectl exec "$(kubectl get pod -l app=ratings -o jsonpath='{.items[0].metadata.name}')" -c ratings -- curl -sS productpage:9080/productpage --user alice:password


curl --user alice:password -i http://$SERVICE_HOST/api/v1/products
kubectl exec "$(kubectl get pod -l app=ratings -o jsonpath='{.items[0].metadata.name}')" -c ratings -- curl -sS productpage:9080/api/v1/products

Alice cant access /api
kubectl exec "$(kubectl get pod -l app=ratings -o jsonpath='{.items[0].metadata.name}')" -c ratings -- curl -sS productpage:9080/api/v1/products --user alice:password


Bob Can Access API
kubectl exec "$(kubectl get pod -l app=ratings -o jsonpath='{.items[0].metadata.name}')" -c ratings -- curl -sS productpage:9080/api/v1/products --user bob:password

BOB CAN ACCESS products
kubectl exec "$(kubectl get pod -l app=ratings -o jsonpath='{.items[0].metadata.name}')" -c ratings -- curl -sS productpage:9080/productpage --user bob:password

kubectl logs opa-6fd9dbb96-89gm8|grep decision