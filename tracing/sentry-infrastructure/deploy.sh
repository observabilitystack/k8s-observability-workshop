#!/bin/bash

cd $(dirname "$0")
set -e

application=$(basename $(pwd))
export ENV_SHA=$(shasum sentry-environment.yml | awk '{print $1}')

echo "🚀  ${application}"
envsubst <sentry-environment.yml | kubectl apply -n tracing  -f -
envsubst <${application}-deployment.yml | kubectl apply -n tracing  -f -
kubectl -n tracing apply -f ${application}-service.yml
echo -e "🙌  Done.\n"
