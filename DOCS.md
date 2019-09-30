# Observability Workshop

## Testing things locally

````
minikube start --vm-driver=hyperkit --memory 8192 --cpus 4
minikube addons enable metrics-server
minikube addons enable ingress
minikube addons enable heapster
````