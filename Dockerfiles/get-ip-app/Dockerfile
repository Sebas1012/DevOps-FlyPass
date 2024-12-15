FROM python:3.12.5-alpine3.20

WORKDIR /usr/src/get_ip

COPY get_ip.py .

RUN pip install requests

VOLUME ["/data"]

CMD ["sh", "-c", "while true; do python3 /usr/src/get_ip/get_ip.py; sleep 60; done"]
