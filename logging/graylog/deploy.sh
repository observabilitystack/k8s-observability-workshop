#!/bin/bash

cd $(dirname "$0")
set -e
application=$(basename $(pwd))
export HOSTNAME="${HOSTNAME:=local}"

echo "🚀  ${application}"
kubectl -n monitoring apply -f ${application}-service.yml
envsubst <${application}-ingress.yml | kubectl apply -n monitoring  -f -
envsubst <${application}-deployment.yml | kubectl apply -n monitoring  -f -
echo -e "🙌  Done.\n"
