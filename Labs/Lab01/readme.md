Book info application
https://raw.githubusercontent.com/istio/istio/release-1.18/samples/bookinfo/platform/kube/bookinfo.yaml
https://raw.githubusercontent.com/istio/istio/release-1.18/samples/bookinfo/networking/bookinfo-gateway.yaml
https://istio.io/latest/docs/setup/getting-started/



opa run --server \
--log-format text \
--set decision_logs.console=true \
--set bundles.play.polling.long_polling_timeout_seconds=45 \
--set services.play.url=https://play.openpolicyagent.org \
--set bundles.play.resource=bundles/Kebbpt5agJ

Test by piping your playground's JSON input into your OPA served playground policy
curl https://play.openpolicyagent.org/v1/input/Kebbpt5agJ \
| curl localhost:8181/v1/data -d @-