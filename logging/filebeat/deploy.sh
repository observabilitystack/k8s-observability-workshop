#!/bin/bash

export FILEBEAT_VERSION=7.9.2
export HOSTNAME="${HOSTNAME:=local}"

cd $(dirname "$0")
set -e

echo "🚀  $(basename $(pwd)) ${FILEBEAT_VERSION}"
export CONF_SHA=$(shasum filebeat-configuration.yml | awk '{print $1}')
kubectl -n monitoring apply -f filebeat-configuration.yml
kubectl -n monitoring apply -f filebeat-rbac.yml
envsubst <filebeat-daemonset.yml | kubectl apply -n monitoring  -f -
echo -e "🙌  Done.\n"
