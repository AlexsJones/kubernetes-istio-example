# kubernetes-istio-quickstart

This demos how HTTP/HTTPS routing with Istio gateway/virtual service work using the latest istio sidecar injection system.

You need to install istio CRD then upload the cert whilst following the steps below.

![image](res/2.png)

## Dependencies
- go get github.com/AlexsJones/vortex
- Admin binding e.g.
```
kubectl create clusterrolebinding cluster-admin-binding \
    --clusterrole=cluster-admin \
    --user=$(gcloud config get-value core/account)
```

## setup

### Optional
```
gcloud container clusters create example-cluster \
--zone us-central1-a \
--node-locations us-central1-a,us-central1-b,us-central1-c --scopes=https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/trace.append,https://www.googleapis.com/auth/devstorage.full_control,https://www.googleapis.com/auth/compute --project=<myproject>
```

and...

```
kubectl create clusterrolebinding cluster-admin-binding \
--clusterrole cluster-admin --user=<yada>
```

### Deployment

#### Istio installation
- Get Istio and install it on the path https://istio.io/docs/setup/kubernetes/download-release/
- Install istio, kubectl create -f <ISTIO_PATH>/install/kubernetes/istio-demo-auth.yaml

#### Example deployment installation
- ./generate_tls_key.sh #Adds a TLS key into istio-system gateway
- kubectl create ns istio-public
- kubectl label namespace istio-public istio-injection=enabled
- ./build_environment.sh default
- kubectl create -f deployment


## Access

```
kubectl get svc/istio-ingressgateway --namespace=istio-system
```

![image](res/1.png)

Use the external IP to access the istio gateway and route to the correct virtual service

You can then add the IP address to /etc/hosts to force the FDQN and you should see we can correctly see the app over https using our generated cert in istio.

e.g. `XX.XXX.XXX.XXX hello-go.com`




## JaegerUI

```
kubectl port-forward -n istio-system $(kubectl get pod -n istio-system -l app=jaeger -o jsonpath='{.items[0].metadata.name}') 16686:16686
```


## Kaili

```
kubectl port-forward -n istio-system $(kubectl get pod -n istio-system -l app=kiali -o jsonpath='{.items[0].metadata.name}') 20001:20001

#http://localhost:20001/kiali/console
```


## Testing

```
curl -H 'Host: hello-go.com' <IPADDR> -L
```
