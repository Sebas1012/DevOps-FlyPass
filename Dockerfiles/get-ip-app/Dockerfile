FROM python:3.12.5-alpine3.20

RUN mkdir -p /data/get_ip && chmod 777 /data/get_ip

WORKDIR /data/get_ip

COPY get_ip.py .

VOLUME ["/data"]

CMD ["python3", "get_ip.py"]
