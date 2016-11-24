FROM alpine:3.4

# Based on: https://hub.docker.com/r/ecor/certbot/~/dockerfile/
MAINTAINER Ho-Sheng Hsiao <hosh@legal.io>
ENV PATH /opt/certbot/venv/bin:$PATH

WORKDIR /opt/certbot
EXPOSE 80 443
VOLUME /etc/certbot/

# Update this to force pull from the latest HEAD
ENV BUILD_DATE 2016-11-23

# && sed -i '/^BIO \*BIO_new_mem_buf(const void \*buf, int len);/ d' /usr/include/openssl/bio.h
RUN set -ex \
    && export BUILD_DEPS="git \
                build-base \
                libffi-dev \
                linux-headers \
                openssl-dev \
                py-pip \
                python-dev" \
    && apk add --no-cache -U dialog \
                python \
                augeas-libs \
    && apk add --no-cache -U ${BUILD_DEPS} --virtual .certbot-builddeps \
    && pip --no-cache-dir install virtualenv \
    && git clone https://github.com/certbot/certbot /opt/certbot/src \
    && (/opt/certbot/src/certbot-auto-source/certbot-auto --os-packages-only || true) \
    && virtualenv --no-site-packages -p python2 /opt/certbot/venv \
    && /opt/certbot/venv/bin/pip install \
                -e /opt/certbot/src/acme \
                -e /opt/certbot/src \
                -e /opt/certbot/src/certbot-apache \
                -e /opt/certbot/src/certbot-nginx \
    && apk del .certbot-builddeps \
    && rm -rf /var/cache/apk/*

ENTRYPOINT ["certbot"]
