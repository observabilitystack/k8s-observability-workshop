#!/bin/bash

cd $(dirname "$0")
set -e

application=$(basename $(pwd))
export GRAFANA_VERSION=6.4.3
export HOSTNAME="${HOSTNAME:=local}"
export DOMAIN_NAME="${DOMAIN_NAME:=k8s.o12stack.org}"
export CONF_SHA=$(shasum ${application}-configuration.yml | awk '{print $1}')
export ENV_SHA=$(shasum ${application}-environment.yml | awk '{print $1}')
export DOLLAR='$'
export SLACK_HOOK_URL=$(echo -n 'aHR0cHM6Ly9ob29rcy5zbGFjay5jb20vc2VydmljZXMvVFBNSDJOMkU4L0JQUTdMMThUWi9jeGlMN1Ftc2JBVnozYXNmSW9qSUZNVWc=' | base64 -d)

echo "🚀  ${application} ${GRAFANA_VERSION}"
envsubst <${application}-configuration.yml | kubectl apply -n monitoring  -f -
envsubst <${application}-environment.yml | kubectl apply -n monitoring  -f -
kubectl -n monitoring apply -f ${application}-service.yml
envsubst <${application}-ingress.yml | kubectl apply -n monitoring  -f -
envsubst <${application}-deployment.yml | kubectl apply -n monitoring  -f -
echo -e "🙌  Done.\n"
