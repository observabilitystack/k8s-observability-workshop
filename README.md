# Observability Workshop W-JAX 2019 // DevOpsCon 2019

These are the resources for the observability workshop we held
at W-JAX and DevOpsCon 2019

## Testing things locally

````
minikube start --vm-driver=hyperkit --memory 8192 --cpus 4
minikube addons enable metrics-server
minikube addons enable ingress
````