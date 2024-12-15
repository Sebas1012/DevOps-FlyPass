FROM alpine:3.21.0

RUN mkdir -p /data/upload_s3 && chmod 777 /data/upload_s3

WORKDIR /data/upload_s3

RUN apk add --no-cache \
    bash \
    curl \
    groff \
    less \
    python3 \
    py3-pip && \
    pip install --no-cache-dir awscli

COPY upload_s3.sh .

ENV S3_BUCKET=dev-flypass-test-s3
ENV S3_OUTPUT_FOLDER=outputs/
ENV LOCAL_FOLDER=/data/ip_log.txt

RUN chmod +x upload_s3.sh

VOLUME ["/data"]

CMD ["./upload_s3.sh"]
