#!/bin/bash

cd $(dirname "$0")
set -e

application=$(basename $(pwd))
export HOSTNAME="${HOSTNAME:=local}"
export ENV_SHA=$(shasum ${application}-environment.yml | awk '{print $1}')

echo "🚀  ${application} ${GRAFANA_VERSION}"
envsubst <${application}-environment.yml | kubectl apply -n monitoring  -f -
kubectl -n monitoring apply -f ${application}-service.yml
envsubst <${application}-ingress.yml | kubectl apply -n monitoring  -f -
envsubst <${application}-deployment.yml | kubectl apply -n monitoring  -f -
echo -e "🙌  Done.\n"
