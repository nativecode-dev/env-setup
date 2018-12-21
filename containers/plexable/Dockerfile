FROM ubuntu:bionic AS BUILD
ENV DEBIAN_FRONTEND noninteractive
ENV PLEXABLE_ARGUMENTS "-frd"

RUN set -ex \
    && apt-get update \
    && apt-get install -y --no-install-recommends apt-utils software-properties-common \
    && add-apt-repository ppa:stebbins/handbrake-releases \
    && apt-get update \
    ;

COPY root/plexable.sh /usr/local/bin/plexable
COPY root/entrypoint.sh /entrypoint.sh

RUN set -ex \
    && apt-get install -y build-essential curl file git handbrake-cli mediainfo \
    && mkdir -p /data \
    && chmod u+x /usr/local/bin/plexable \
    && chmod u+x /entrypoint.sh \
    ;

WORKDIR /data
VOLUME /data

CMD ["/bin/bash", "-c", "/entrypoint.sh"]
