KEY=thisisademo
openssl genrsa -des3 -passout pass:$KEY -out server.pass.key 2048
openssl rsa -passin pass:$KEY -in server.pass.key -out server.key
rm server.pass.key
openssl req -new -key server.key -out server.csr -subj "/CN=hello-go.com"
openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt
kubectl create secret tls istio-ingressgateway-certs --cert=server.crt --key=server.key --namespace=istio-system --force
