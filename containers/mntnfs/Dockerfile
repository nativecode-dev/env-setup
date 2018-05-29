FROM alpine:latest

ADD /root/entry.sh /usr/local/bin/entry.sh

ENV FSTYPE nfs
ENV FSVERSION 4
ENV NFSVER nfsvers=$FSVERSION
ENV MOUNT_OPTIONS ro
ENV MOUNTPOINT /mnt/data

RUN  set -ex \
  && apk update \
  && apk add --update --no-cache nfs-utils \
  && rm /sbin/halt /sbin/poweroff /sbin/reboot \
  && chmod +x /usr/local/bin/entry.sh \
  ;

ENTRYPOINT [ "/usr/local/bin/entry.sh" ]
