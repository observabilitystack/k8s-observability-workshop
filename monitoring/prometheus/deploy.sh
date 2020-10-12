#!/bin/bash

cd $(dirname "$0")
set -e

application=$(basename $(pwd))
export PROMETHEUS_VERSION=v2.21.0
export HOSTNAME="${HOSTNAME:=local}"
export DOMAIN_NAME="${DOMAIN_NAME:=k8s.o12stack.org}"
export CONF_SHA=$(shasum ${application}-configuration.yml | awk '{print $1}')

echo "🚀  ${application} ${PROMETHEUS_VERSION}"
envsubst <${application}-configuration.yml | kubectl apply -n monitoring  -f -
kubectl -n monitoring apply -f ${application}-service.yml
kubectl -n monitoring apply -f ${application}-rbac.yml
envsubst <${application}-ingress.yml | kubectl apply -n monitoring  -f -
envsubst <${application}-deployment.yml | kubectl apply -n monitoring  -f -
echo -e "🙌  Done.\n"
