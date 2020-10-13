#!/bin/bash

export LOGSTASH_VERSION=7.9.2

cd $(dirname "$0")
set -e

echo "🚀  $(basename $(pwd)) ${LOGSTASH_VERSION}"
export CONF_SHA=$(shasum logstash-configuration.yml | awk '{print $1}')
kubectl -n monitoring apply -f logstash-configuration.yml
kubectl -n monitoring apply -f logstash-service.yml
envsubst <logstash-deployment.yml | kubectl apply -n monitoring  -f -
echo -e "🙌  Done.\n"
