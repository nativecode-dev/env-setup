FROM linuxserver/sonarr:latest

ENV DEBIAN_FRONTEND=noninteractive
ENV SERVER="localhost"
ENV SHARE="/"
ENV OPTIONS="rw"
ENV MOUNT="/tv"
ENV NFSVER="4"

COPY /root/docker-entry.sh /docker-entry.sh

RUN set -ex \
  # Update packages
  && apt-get update \
  && apt-get upgrade -y \
  # Install NFS client
  && apt-get install -y rpcbind nfs-common \
  # Cleanup
  && apt-get autoremove -y \
  && apt-get autoclean -y \
  ;

CMD [ "/docker-entry.sh" ]
