FROM alpine:latest

WORKDIR /usr/local/backup/

RUN apk add --no-cache bash gawk sed grep bc coreutils curl git openssh openssl

RUN apk add --no-cache python3 && \
    python3 -m ensurepip && \
    rm -r /usr/lib/python*/ensurepip && \
    pip3 install --upgrade pip setuptools && \
    if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi && \
    if [[ ! -e /usr/bin/python ]]; then ln -sf /usr/bin/python3 /usr/bin/python; fi && \
    rm -r /root/.cache

RUN apk add --no-cache py3-gpgme gnupg

RUN pip3 install --upgrade awscli==1.16.67 s3cmd==2.0.2 python-magic python-gnupg 

RUN gpg || true

ADD ./ /backup-base

RUN cd  /backup-base/ && python3.7 /backup-base/setup.py install

WORKDIR /