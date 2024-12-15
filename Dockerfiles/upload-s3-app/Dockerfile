FROM amazonlinux:2

WORKDIR /data/upload_s3

RUN yum install -y aws-cli bash

COPY upload_s3.sh ./

ENV S3_BUCKET=dev-flypass-test-s3
ENV S3_OUTPUT_FOLDER=outputs/
ENV LOCAL_FOLDER=/data/ip_log.txt

RUN chmod +x upload_s3.sh

VOLUME ["/data"]

CMD ["./upload_s3.sh"]
