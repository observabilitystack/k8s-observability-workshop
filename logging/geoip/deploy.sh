#!/bin/bash

cd $(dirname "$0")
set -e
application=$(basename $(pwd))
export HOSTNAME="${HOSTNAME:=local}"
export DOMAIN_NAME="${DOMAIN_NAME:=k8s.o12stack.org}"

echo "🚀  ${application}"
kubectl -n monitoring apply -f ${application}-service.yml
envsubst <${application}-ingress.yml | kubectl apply -n monitoring  -f -
envsubst <${application}-deployment.yml | kubectl apply -n monitoring  -f -
echo -e "🙌  Done.\n"
