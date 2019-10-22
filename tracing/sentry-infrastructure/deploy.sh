#!/bin/bash

cd $(dirname "$0")
set -e

application=$(basename $(pwd))

echo "🚀  ${application}"
kubectl -n tracing apply -f ${application}-deployment.yml
kubectl -n tracing apply -f ${application}-service.yml
echo -e "🙌  Done.\n"
