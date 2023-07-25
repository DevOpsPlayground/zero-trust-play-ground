#!/bin/bash

set -e
set -o pipefail
set -u

# Verify Istio Installation
# istioctl verify-install -f istio-1.18.0/manifests/profiles/default.yaml


#istioctl install -f istio.yaml --dry-run
istioctl version
# istioctl x uninstall --purge -y

istioctl install -f istio.yaml --set values.global.logging.level=debug -y
istioctl verify-install -f istio.yaml

# Configuration - https://istio.io/latest/docs/reference/config/istio.operator.v1alpha1/

kubectl -n istio-system get IstioOperator installed-state

kubectl -n istio-system get deploy


# Next Install Ingressgateway

istioctl install -f ingress.yaml --set values.global.logging.level=debug -y



export INGRESS_HOST=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.status.loadBalancer.ingress[0].ip}')

export INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="http2")].port}')

export SECURE_INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="https")].port}')


export TCP_INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="tcp")].port}')




printenv INGRESS_PORT SECURE_INGRESS_PORT TCP_INGRESS_PORT INGRESS_HOST