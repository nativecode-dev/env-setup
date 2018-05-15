FROM wordpress:fpm-alpine

RUN set -ex \
  && apk --update --no-cache add libzip  libzip-dev \
  && docker-php-ext-configure zip --with-libzip \
  && docker-php-ext-install zip  \
  && apk del libzip-dev \
  ;
