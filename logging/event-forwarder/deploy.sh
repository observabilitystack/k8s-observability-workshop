#!/bin/bash

cd $(dirname "$0")
set -e
application=$(basename $(pwd))

echo "🚀  ${application}"
kubectl -n monitoring apply -f ${application}-serviceaccount.yml
envsubst <${application}-deployment.yml | kubectl apply -n monitoring  -f -
echo -e "🙌  Done.\n"
