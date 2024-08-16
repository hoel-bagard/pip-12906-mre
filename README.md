# PIP 12906 MRE

Minimal reproducible example for [pip issue 12906](https://github.com/pypa/pip/issues/12906).

## Reproduction steps

Tested with:

- Docker version `27.1.1`
- Python `3.10.4`
- virtualenv `20.23.0`

### Build the docker:

```console
docker build -t pip-12906-mre .
```

### Start the server

```bash
docker run \
    -dt \
    --rm \
    --name pip-12906-mre \
    -p 3141:3141 \
    -p 80:80 \
    -p 443:443 \
    pip-12906-mre
```

You can then access it at `https://localhost:443/`.

### Try using the index

First upgrade the pip version to `24.2` (should work fine).\
Then try to install another package (for example `pip==24.1`), the `ValueError: check_hostname requires server_hostname` error should occur.

```bash
virtualenv .venv; source .venv/bin/activate
pip install --index-url https://127.0.0.1/root/pypi pip==24.2 --cert assets/ca.pem  # Fine
pip install --index-url https://127.0.0.1/root/pypi pip==24.1 --cert assets/ca.pem  # Error
```

## Other

The certificates were generated with the following commands:

<details>
<summary>commands</summary>

```console
# CA certificate
openssl genrsa -out assets/ca-key.pem 4096
openssl req -new -x509 -days 3650 -subj "/C=JP/O=Test/CN=Test/emailAddress=test@test.com" -addext "subjectAltName=IP:127.0.0.1" -key assets/ca-key.pem -out assets/ca.pem
# Devpi certificate
openssl genrsa -out assets/cert-key.pem 4096
openssl req -new -sha256 -subj "/C=JP/O=Test/CN=Test/emailAddress=test@test.com" -addext "subjectAltName=IP:127.0.0.1" -key assets/cert-key.pem -out assets/cert.csr
openssl x509 \
  -req \
  -sha256 \
  -days 3650 \
  -in assets/cert.csr \
  -CA assets/ca.pem \
  -CAkey assets/ca-key.pem \
  -out assets/devpi-cert.pem \
  -subj "/C=JP/O=Test/CN=Test/emailAddress=test@test.com" \
  -extfile <(printf "subjectAltName=IP:127.0.0.1")
```

</details>
