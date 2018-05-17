FROM wordpress:fpm-alpine

RUN set -ex \
  && apk --no-cache --update add libzip \
  && apk --no-cache --virtual .deps add libzip-dev \
  && docker-php-ext-configure zip --with-libzip \
  && docker-php-ext-install zip  \
  && apk del .deps \
  ;
