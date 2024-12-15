#!/bin/bash

S3_BUCKET=${S3_BUCKET}
S3_OUTPUT_FOLDER=${S3_OUTPUT_FOLDER}
LOCAL_FOLDER=${LOCAL_FOLDER}

upload_to_s3() {
  local file_path=$1
  local file_name=$(basename "$file_path")
  local s3_key="${S3_OUTPUT_FOLDER}${file_name}"

  echo "Subiendo archivo $file_path a s3://$S3_BUCKET/$s3_key"
  aws s3 cp "$file_path" "s3://$S3_BUCKET/$s3_key"

  if [ $? -eq 0 ]; then
    echo "Archivo $file_name subido exitosamente."
    rm -f "$file_path"
    echo "Archivo $file_name eliminado localmente."
  else
    echo "Error al subir $file_name a S3."
  fi
}


while true; do
  echo "Buscando archivos en $LOCAL_FOLDER..."
  for file_path in "$LOCAL_FOLDER"/*; do
    if [ -f "$file_path" ]; then
      upload_to_s3 "$file_path"
    fi
  done

  echo "Esperando 1 hora antes de la siguiente verificación..."
  sleep 3600
done
