#!/bin/bash

export HOSTNAME="${HOSTNAME:=local}"

cd $(dirname "$0")
set -e

echo "🚀  $(basename $(pwd))"
kubectl -n monitoring apply -f graylog-service.yml
envsubst <graylog-ingress.yml | kubectl apply -n monitoring  -f -
envsubst <graylog-deployment.yml | kubectl apply -n monitoring  -f -
echo -e "🙌  Done.\n"
