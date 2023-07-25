Installation process to deploy opa using CUSTOM authorization policy and external authorizer
------------------------------------------------------------------------------------------------
Prerequisite:
------------
Ensure that your namespace is istio enabled

run: 
kubectl get namespace <your namespace> --show-labels

One of the labels should show istio-injection=enabled
 --- istio-injection=enabled,kubernetes.io/metadata.name=default

Else run the following command to enable istio in your namespace
 run:
 kubectl label namespace <your namespace> istio-injection=enabled --overwrite


Step 1. Deploy policy.yaml - This will deploy the prewritten opa policy in a k8 configmap
----------------------------------------------------------------------------------------
run:
kubectl apply -f policy.yaml -n <your namespace>

To verify that the policy has been successfully created
run:
kubect get configmap opa-policy -n <your namespace>


Step 2. Deploy the opa policy engine in your namespace
-------------------------------------------------------------------------------------
run:
kubectl apply -f opa.yaml -n <your namespace>

To verify that the pods is started and running

run:
kubectl get pods -n default -l='app=opa'

get opa pod name:
run:
echo $(kubectl -n <your namespace> get pods -o=jsonpath='{.items[?(@.metadata.labels.app=="opa")].metadata.name}')


SETP 3: Deploy external authorizer for opa into the istio control plane
-----------------------------------------------------------------------
edit the file istio-configmap.sh
change or set the value of the following variables to that of your namespace
PROJECT_ID=default

replace:
PROJECT_ID=<your namespace>
save file

run:
./istio-configmap.sh

to confirm successful installation:

run:
kubectl get configmap istio -n istio-system -o yaml

you would see your entry in the istio meshconfig
    extensionProviders:
    - name: "opa.<your namespace>"
      envoyExtAuthzGrpc:
        service: "opa.<your namespace>.svc.cluster.local"
        port: "9191"

STEP 4: Deploy AuthorizationPolicy - this will be updated once the application has been deployed
edit the file auth-policy.sh

change or set the value of the following variables to that of your namespace
PROJECT_ID=default
AUTH_APP_LABEL=bookinfo-app

replace:
PROJECT_ID=<your namespace>
AUTH_APP_LABEL=<app label>
save file

run:
./auth-policy.sh