#!/bin/bash

cd $(dirname "$0")
set -e

export CHECKMK_VERSION=1.5.0p21
export HOSTNAME="${HOSTNAME:=local}"
application=$(basename $(pwd))

echo "🚀  ${application} ${CHECKMK_VERSION}"
kubectl apply -n monitoring  -f ${application}-service.yml
envsubst <${application}-ingress.yml | kubectl apply -n monitoring  -f -
envsubst <${application}-daemonset.yml | kubectl apply -n monitoring  -f -
echo -e "🙌  Done.\n"
