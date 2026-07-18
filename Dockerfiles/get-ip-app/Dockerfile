FROM python:3.13-alpine3.22

RUN adduser -D -u 10001 app

WORKDIR /app
COPY get_ip.py .

USER app

ENTRYPOINT ["python3", "/app/get_ip.py"]
