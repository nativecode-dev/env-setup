FROM ubuntu:bionic

ARG VERSION=4.9

ENV DEBIAN_FRONTEND=noninteractive

ENV IMDB_FTP="ftp://ftp.fu-berlin.de/pub/misc/movies/database/frozendata/"
ENV MYSQL_DATABASE="imdbpy"
ENV MYSQL_HOST="imdbpy"
ENV MYSQL_USER="imdbpy"
ENV MYSQL_PASSWORD="imdbpy"

WORKDIR /opt

RUN set -ex \
  && apt-get update \
  && apt-get install -y git python3-pip wget \
  ;

ADD /root/docker-entry.sh /docker-entry.sh

RUN set -ex \
  && pip3 install imdbpy \
  && chmod +x /docker-entry.sh \
  ;

VOLUME /data

CMD [ "/docker-entry.sh" ]
