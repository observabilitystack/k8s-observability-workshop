#!/bin/bash

cd $(dirname "$0")
set -e
application=$(basename $(pwd))
export HOSTNAME="${HOSTNAME:=local}"
export DOMAIN_NAME="${DOMAIN_NAME:=k8s.o12stack.org}"
export CONF_SHA=$(shasum ${application}-configuration.yml | awk '{print $1}')

echo "🚀  ${application}"
kubectl -n monitoring apply -f ${application}-service.yml
kubectl -n monitoring apply -f ${application}-configuration.yml
envsubst <${application}-deployment.yml | kubectl apply -n monitoring  -f -
echo -e "🙌  Done.\n"
