FROM alpine:latest

ADD /root/entry.sh /usr/local/bin/entry.sh

ENV FSTYPE nfs
ENV MOUNT_OPTIONS nfsvers=4
ENV MOUNTPOINT /mnt/data

RUN  set -ex \
  && apk update \
  && apk add --update --no-cache nfs-utils \
  && rm /sbin/halt /sbin/poweroff /sbin/reboot \
  && chmod +x /usr/local/bin/entry.sh \
  ;

ENTRYPOINT [ "/usr/local/bin/entry.sh" ]
