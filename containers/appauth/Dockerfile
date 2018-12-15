FROM nginx:alpine
LABEL maintainer "opensource@nativecode.com"

ENV AUTH_REALM="Restricted" \
  FORWARD_PROTOCOL="http" \
  FORWARD_HOST="localhost" \
  FORWARD_PORT="8080" \
  FORWARD_PATH="" \
  HTPASSWD_FILE="/etc/nginx/auth.d/auth.htpasswd" \
  HTPASSWD="" \
  LISTEN_PORT="80"

COPY /root/auth.conf /etc/nginx/conf.d/
COPY /root/entrypoint.sh /entrypoint.sh

RUN apk add --update --no-cache gettext \
  && mkdir -p /etc/nginx/auth.d \
  && rm /etc/nginx/conf.d/default.conf \
  && touch /etc/nginx/auth.d/auth.htpasswd \
  && chmod +x /entrypoint.sh \
  ;

VOLUME /etc/nginx/auth.d

CMD [ "/entrypoint.sh" ]
