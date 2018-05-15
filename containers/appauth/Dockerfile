FROM nginx:alpine
LABEL maintainer "opensource@nativecode.com"

ENV AUTH_REALM="Restricted" \
  FORWARD_HOST="localhost" \
  FORWARD_PORT="8080" \
  FORWARD_PROTOCOL="http" \
  HTPASSWD_FILE="/etc/nginx/conf.d/auth.htpasswd" \
  HTPASSWD="" \
  LISTEN_PORT="80"

COPY /root/auth.conf /etc/nginx/conf.d/
COPY /root/entrypoint.sh /entrypoint.sh

RUN apk add --update --no-cache gettext \
  && rm /etc/nginx/conf.d/default.conf \
  && touch /etc/nginx/conf.d/auth.htpasswd \
  && chmod +x /entrypoint.sh \
  ;

CMD [ "/entrypoint.sh" ]
