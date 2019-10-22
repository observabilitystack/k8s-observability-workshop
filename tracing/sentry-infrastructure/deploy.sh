#!/bin/bash

cd $(dirname "$0")
set -e

application=$(basename $(pwd))

echo "🚀  ${application}"
envsubst <${application}-deployment.yml | kubectl apply -n tracing  -f -
kubectl -n tracing apply -f ${application}-service.yml
echo -e "🙌  Done.\n"
