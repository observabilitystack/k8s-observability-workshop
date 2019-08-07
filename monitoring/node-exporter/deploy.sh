#!/bin/bash

cd $(dirname "$0")
set -e

export NODE_EXPORTER_VERSION=v0.18.1
application=$(basename $(pwd))

echo "🚀  ${application} ${NODE_EXPORTER_VERSION}"
envsubst <${application}-daemonset.yml | kubectl apply -n monitoring  -f -
echo -e "🙌  Done.\n"
