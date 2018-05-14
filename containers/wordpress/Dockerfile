FROM wordpress:fpm-alpine

RUN set -ex \
    && apk --update --no-cache add zlib-dev \
    # && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-install zip  \
    && apk del zlib-dev \
    ;
