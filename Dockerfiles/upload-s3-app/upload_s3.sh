#!/bin/bash

while true; do
  aws s3 cp /data/ip_log.txt s3://dev-flypass-test-s3/outputs/$(date +%s).txt

  echo "Esperando 1 hora antes de la siguiente verificación..."
  sleep 60
done
