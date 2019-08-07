#!/bin/bash

cd $(dirname "$0")
set -e

application=$(basename $(pwd))
export KUBE_RESOURCE_REPORT_VERSION=0.15
export HOSTNAME="${HOSTNAME:=local}"

echo "🚀  ${application} ${KUBE_RESOURCE_REPORT_VERSION}"
kubectl -n monitoring apply -f service.yaml
kubectl -n monitoring apply -f rbac.yaml
envsubst <ingress.yaml | kubectl apply -n monitoring  -f -
envsubst <deployment.yaml | kubectl apply -n monitoring  -f -
echo -e "🙌  Done.\n"
