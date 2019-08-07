#!/bin/bash

export HOSTNAME="${HOSTNAME:=local}"

set -e

echo "🔌  Configuring Graylog TCP input"
curl -sS --request POST \
  --url https://logs.${HOSTNAME}.k8s.o12stack.org/api/system/inputs \
  --header 'authorization: Basic YWRtaW46bzEyc3RhY2s=' \
  --header 'content-type: application/json' \
  --header 'x-requested-by: k8s-observability-workshop' \
  --data '{
  "title": "gelf-tcp",
  "type": "org.graylog2.inputs.gelf.tcp.GELFTCPInput",
  "configuration": {
    "bind_address": "0.0.0.0",
    "port": 12201
  },
  "global": true
}'
echo -e "🙌  Done.\n"
