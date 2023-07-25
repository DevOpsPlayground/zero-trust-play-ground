#!/bin/bash
set -e
set -o pipefail
set -u


# script to auto insert the following section into the istio configmap 
#    - name: "opa.onboarding"
#      envoyExtAuthzGrpc:
#        service: "opa.onboarding.svc.cluster.local"
#        port: "9191"


PROJECT_ID=default
# Check to see if the namespace has the "-" character and replace with emptry char ""
#  The external service name must not contain a dash [    - name: "opa.default"] in the istio configmap
if [[ $PROJECT_ID =~ "-" ]]; then
  echo "namespace $PROJECT_ID has [-], removing character istio configmap opa ext service name"
  PROJECT_REP_ID=${PROJECT_ID//[-]/""}
  echo "PROJECT_REP_ID = $PROJECT_REP_ID"
else
  PROJECT_REP_ID=$PROJECT_ID
  echo "PROJECT_REP_ID = $PROJECT_REP_ID"
fi

# update the set-istio-config.yaml file with values from PROJECT_ID or _PROJECT_REP_ID where [-] is found - - see above explanation
sed -i "s@<PROJECT_ID>@${PROJECT_ID}@g;s@<PROJECT_REP_ID>@${PROJECT_REP_ID}@g" namespace-opa/set-istio-config.yaml
cat namespace-opa/set-istio-config.yaml

if [[ $(kubectl get configmap istio -n istio-system -o yaml | grep -c "extensionProviders:")  -ge 1 ]]; then
 echo "ExtensionsProvider exist in mesh config and annotations"
 echo "skipping"
else
	echo "ExtensionsProvider does not exists"
	echo " Adding Extensions Provider to meshconfig"
   kubectl get configmap istio -n istio-system -o yaml | sed '0,/enablePrometheusMerge: true/s//&\n \ \ \ \extensionProviders:/'| kubectl apply -f -
fi




kubectl get configmap istio -n istio-system -o yaml > namespace-opa/istio-configmap-k8.yaml

# cat namespace-opa/istio-configmap-k8.yaml

# Check to see if there already exists an entry for opa external service in the istio config map or istio-configmap.yaml file 
if grep -F "opa.$PROJECT_ID" namespace-opa/istio-configmap-k8.yaml; then
 echo "found a an entry of opa external injection in istio istio-configmap.yaml"
 echo "Please remove entry in istio configmap in istio-system namespace and continue"
 cat namespace-opa/istio-configmap-k8.yaml
 exit 1
else
# sed '0,/extensionProviders:/r' only removes the first entry of extensionProviders as there are multiples in the istio configmap yaml
#  sed -i '/extensionProviders:/r namespace-opa/set-istio-config.yaml' namespace-opa/istio-configmap-k8.yaml
 sed -i '0,/extensionProviders:/ {
  /extensionProviders:/ r namespace-opa/set-istio-config.yaml
  }' namespace-opa/istio-configmap-k8.yaml
  
  cat namespace-opa/istio-configmap-k8.yaml
# yamllint is used here to capture errors in the yaml file and help troubleshoot
  # yamllint namespace-opa/istio-configmap-k8.yaml
  kubectl apply -f namespace-opa/istio-configmap-k8.yaml
fi