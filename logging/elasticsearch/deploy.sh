#!/bin/bash

export ELASTICSEARCH_VERSION=7.2.0

cd $(dirname "$0")
set -e

echo "🚀  $(basename $(pwd)) ${ELASTICSEARCH_VERSION}"
kubectl -n monitoring apply -f es-service.yml
kubectl -n monitoring apply -f es-ingress.yml
envsubst <es-deployment.yml | kubectl apply -n monitoring  -f -
echo -e "🙌  Done.\n"
