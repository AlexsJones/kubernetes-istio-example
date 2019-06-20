KEY=thisisademo
openssl genrsa -passout pass:$KEY -out server.key 2048

openssl req -new -key server.key -out server.csr -subj "/C=GB/ST=London/L=London/O=Testing Istio/OU=IT Department/CN=hello-go.com"

openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt

kubectl create secret tls istio-ingressgateway-certs --cert=server.crt --key=server.key --namespace=istio-system
