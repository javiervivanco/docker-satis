FROM alpine:latest
ENV PHP_MEMORY_LIMIT=2048M
RUN apk update
RUN apk add -u musl  --no-progress 
RUN apk add --no-progress \
    git \
    php-curl  \
    php-mcrypt \
    php-openssl  \
    php-phar  \
    php-zip \
    php-cli \
    php-json \
    php-iconv \
    php-ctype \
    openssl \
    openssh-client \
    ca-certificates
ADD https://getcomposer.org/composer.phar /usr/local/bin/composer
ADD http://curl.haxx.se/ca/cacert.pem /etc/ssl/certs/
RUN echo "openssl.cafile=/etc/ssl/certs/cacert.pem" >>  /etc/php/conf.d/openssl.ini
RUN echo "openssl.capath=/etc/ssl/certs/" >>  /etc/php/conf.d/openssl.ini
RUN sed -i  "s/memory_limit = 128M/memory_limit = $PHP_MEMORY_LIMIT/g" /etc/php/php.ini  
RUN mkdir -p /data/satis
RUN chmod +x /usr/local/bin/composer
ENV SATIS_PATH="/data/satis"
ENV SATIS_SRC="${SATIS_PATH}/src"
ENV SATIS_BIN="${SATIS_SRC}/bin/satis"
ENV SATIS_PUBLIC="${SATIS_PATH}/web"
ENV SATIS_CONFIG="${SATIS_PATH}/config/satis.json"
RUN composer create-project composer/satis  --prefer-dist --stability=dev --keep-vcs ${SATIS_SRC}
ADD entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
VOLUME ["/data/satis/config/", "/data/satis/web/", "/root/.ssh/", "/root/.composer/"]
