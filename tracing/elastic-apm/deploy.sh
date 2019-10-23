#!/bin/bash

cd $(dirname "$0")
set -e

application=$(basename $(pwd))
export ELASTIC_VERSION=7.4.0
export HOSTNAME="${HOSTNAME:=local}"
export DOMAIN_NAME="${DOMAIN_NAME:=k8s.o12stack.org}"

echo "🚀  ${application} ${ELASTIC_VERSION}"
kubectl -n tracing apply -f ${application}-service.yml
envsubst <${application}-configuration.yml | kubectl apply -n tracing  -f -
envsubst <${application}-ingress.yml | kubectl apply -n tracing  -f -
envsubst <${application}-deployment.yml | kubectl apply -n tracing  -f -
echo -e "🙌  Done.\n"
