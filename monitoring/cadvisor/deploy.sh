#!/bin/bash

cd $(dirname "$0")
set -e

application=$(basename $(pwd))

echo "🚀  ${application}"
kubectl -n monitoring apply -k .
echo -e "🙌  Done.\n"
