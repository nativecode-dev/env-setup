FROM alpine:latest

ADD /root/entry.sh /usr/local/bin/entry.sh

ENV SERVER localhost
ENV SHARE /
ENV MOUNT_OPTIONS ro
ENV MOUNT_POINT /mnt/data

RUN  set -ex \
  && apk update \
  && apk add --update --no-cache nfs-utils \
  && rm /sbin/halt /sbin/poweroff /sbin/reboot \
  && chmod +x /usr/local/bin/entry.sh \
  ;

ENTRYPOINT [ "/usr/local/bin/entry.sh" ]
