#!/bin/bash

cd $(dirname "$0")
set -e
application=$(basename $(pwd))
export HOSTNAME="${HOSTNAME:=local}"
export DOMAIN_NAME="${DOMAIN_NAME:=k8s.o12stack.org}"

echo "🚀  ${application}"
kubectl -n apps apply -f ${application}-service.yml
envsubst <${application}-ingress.yml | kubectl apply -n apps  -f -
envsubst <${application}-deployment.yml | kubectl apply -n apps  -f -
echo -e "🙌  Done.\n"
