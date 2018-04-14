FROM nginx:alpine
LABEL maintainer "opensource@nativecode.com"

ENV AUTH_REALM="Restricted" \
	FORWARD_HOST="example.com" \
	FORWARD_PORT=8080 \
	FORWARD_PROTOCOL="http" \
	HTPASSWD_FILE="/etc/nginx/conf.d/auth.htpasswd" \
	HTPASSWD="" \
	LISTEN_PORT=80

RUN apk add --no-cache gettext \
	&&	rm /etc/nginx/conf.d/default.conf \
	;

ADD auth.conf auth.htpasswd /etc/nginx/conf.d/
ADD start.sh /

CMD ["/start.sh"]
