#!/bin/bash

cd $(dirname "$0")
set -e

application=$(basename $(pwd))
export HOSTNAME="${HOSTNAME:=local}"
export DOMAIN_NAME="${DOMAIN_NAME:=k8s.o12stack.org}"
export ENV_SHA=$(shasum ${application}-environment.yml | awk '{print $1}')

echo "🚀  ${application}"
envsubst <${application}-environment.yml | kubectl apply -n tracing  -f -
kubectl -n tracing apply -f ${application}-service.yml
envsubst <${application}-ingress.yml | kubectl apply -n tracing  -f -
envsubst <${application}-deployment.yml | kubectl apply -n tracing  -f -
echo -e "🙌  Done.\n"
