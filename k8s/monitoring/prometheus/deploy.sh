#!/bin/bash

cd $(dirname "$0")
set -e

application=$(basename $(pwd))
PROMETHEUS_VERSION=v2.11.1
HOSTNAME="${HOSTNAME:=local}"
CONF_SHA=$(shasum ${application}-configuration.yml | awk '{print $1}')

echo "🚀  ${application} ${PROMETHEUS_VERSION}"
kubectl -n monitoring apply -f ${application}-configuration.yml
kubectl -n monitoring apply -f ${application}-service.yml
kubectl -n monitoring apply -f ${application}-rbac.yml
envsubst <${application}-ingress.yml | kubectl apply -n monitoring  -f -
envsubst <${application}-deployment.yml | kubectl apply -n monitoring  -f -
echo -e "🙌  Done.\n"