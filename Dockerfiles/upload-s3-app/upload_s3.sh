#!/bin/sh
set -eu

: "${S3_BUCKET:?La variable S3_BUCKET es requerida}"
TIMEOUT_SECONDS="${TIMEOUT_SECONDS:-120}"

elapsed=0
file=""
while [ -z "$file" ]; do
  file=$(find /data -maxdepth 1 -name '*.txt' | head -n 1)
  if [ -z "$file" ]; then
    if [ "$elapsed" -ge "$TIMEOUT_SECONDS" ]; then
      echo '{"level":"error","event":"timeout_waiting_file","timeout_seconds":'"$TIMEOUT_SECONDS"'}' >&2
      exit 1
    fi
    sleep 2
    elapsed=$((elapsed + 2))
  fi
done

key="outputs/$(basename "$file")"
aws s3 cp "$file" "s3://${S3_BUCKET}/${key}" --only-show-errors

echo '{"level":"info","event":"uploaded","bucket":"'"$S3_BUCKET"'","key":"'"$key"'"}'
