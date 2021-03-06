#!/bin/bash

cd $(dirname "$0")
set -e

application=$(basename $(pwd))
export ELASTIC_VERSION=7.9.1
export HOSTNAME="${HOSTNAME:=local}"
export DOMAIN_NAME="${DOMAIN_NAME:=k8s.o12stack.org}"
export CONF_SHA=$(shasum ${application}-configuration.yml | awk '{print $1}')

echo "🚀  ${application} ${ELASTIC_VERSION}"
kubectl -n tracing apply -f ${application}-service.yml
envsubst <${application}-configuration.yml | kubectl apply -n tracing  -f -
envsubst <${application}-ingress.yml | kubectl apply -n tracing  -f -
envsubst <${application}-deployment.yml | kubectl apply -n tracing  -f -
echo -e "🙌  Done.\n"
