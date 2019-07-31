#!/bin/bash

cd $(dirname "$0")
set -e
application=$(basename $(pwd))

echo "🚀  ${application}"
kubectl -n monitoring apply -f ${application}-serviceaccount.yml
kubectl -n monitoring apply -f ${application}-deployment.yml
echo -e "🙌  Done.\n"
