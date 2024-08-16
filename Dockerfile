FROM python:3.11

EXPOSE 80
EXPOSE 443
EXPOSE 3141

RUN apt-get -y update && \
    apt-get -y install nginx=1.22.1-9 --no-install-recommends \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir \
    devpi-client==7.0.3 \
    devpi-server==6.12.0 \
    devpi-web==4.2.2 \
    devpi-constrained==2.0.1

COPY src/nginx.conf /etc/nginx/nginx.conf
COPY assets/devpi-cert.pem /etc/nginx/certs/cert.crt
COPY assets/cert-key.pem /etc/nginx/certs/cert.key
COPY src/entrypoint.sh /scripts/entrypoint.sh

WORKDIR /data

ENTRYPOINT ["/scripts/entrypoint.sh"]
