#!/bin/bash

cd $(dirname "$0")
set -e

application=$(basename $(pwd))
export KUBE_REPORT_VERSION=v2.11.1
export HOSTNAME="${HOSTNAME:=local}"

echo "🚀  ${application} ${KUBE_REPORT_VERSION}"
kubectl -n monitoring apply -f ${application}-configuration.yml
kubectl -n monitoring apply -f ${application}-service.yml
kubectl -n monitoring apply -f ${application}-rbac.yml
envsubst <${application}-ingress.yml | kubectl apply -n monitoring  -f -
envsubst <${application}-deployment.yml | kubectl apply -n monitoring  -f -
echo -e "🙌  Done.\n"
