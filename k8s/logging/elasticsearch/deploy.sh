#!/bin/bash

export ELASTICSEARCH_VERSION=7.2.0
export HOSTNAME="${HOSTNAME:=local}"

cd $(dirname "$0")
set -e

echo "🚀  $(basename $(pwd)) ${ELASTICSEARCH_VERSION}"
kubectl -n monitoring apply -f es-service.yml
envsubst <es-ingress.yml | kubectl apply -n monitoring  -f -
envsubst <es-deployment.yml | kubectl apply -n monitoring  -f -
echo -e "🙌  Done.\n"
