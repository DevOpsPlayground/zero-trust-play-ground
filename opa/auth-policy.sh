#!/bin/bash
set -e
set -o pipefail
set -u

PROJECT_ID=default
AUTH_APP_LABEL=bookinfo-app

if [[ $PROJECT_ID =~ "-" ]]; then
  echo "namespace $PROJECT_ID has [-], removing character istio configmap opa ext service name"
  PROJECT_REP_ID=${PROJECT_ID//[-]/""}
  echo "PROJECT_REP_ID = $PROJECT_REP_ID"
else
  PROJECT_REP_ID=$PROJECT_ID
  echo "PROJECT_REP_ID = $PROJECT_REP_ID"
fi

# update the sauth-policy.yaml file with values from PROJECT_ID or _PROJECT_REP_ID where [-] is found - - see above explanation
sed -i "s@<PROJECT_ID>@${PROJECT_ID}@g;s@<PROJECT_REP_ID>@${PROJECT_REP_ID}@g;s@<AUTH_APP_LABEL>@${AUTH_APP_LABEL}@g" namespace-opa/auth-policy.yaml

cat namespace-opa/auth-policy.yaml

kubectl apply -f namespace-opa/auth-policy.yaml -n $PROJECT_ID