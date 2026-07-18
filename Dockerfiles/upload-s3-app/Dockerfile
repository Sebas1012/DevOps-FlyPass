FROM alpine:3.22

RUN apk add --no-cache aws-cli \
    && adduser -D -u 10001 app

WORKDIR /app
COPY upload_s3.sh .
RUN chmod 0755 upload_s3.sh

USER app

ENTRYPOINT ["/app/upload_s3.sh"]
