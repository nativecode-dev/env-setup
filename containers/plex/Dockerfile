FROM plexinc/pms-docker:latest

ENV WEBTOOLS_RELEASE "3.0.0"
ENV WEBTOOLS_RELEASE_URL https://github.com/ukdtom/WebTools.bundle/releases/download/$WEBTOOLS_RELEASE/WebTools.bundle.zip

ADD /root/etc/cont-init.d/30-mount-shares /etc/cont-init.d/30-mount-shares

RUN set -ex \
  && apt-get update \
  && apt-get install -y unzip \
  && curl -L -o WebTools.bundle.zip $WEBTOOLS_RELEASE_URL \
  && ls -lah \
  ;

RUN set -ex \
  && mkdir -p /config/Library/Application\ Support/Plex\ Media\ Server/Plug-ins/ \
  && unzip WebTools.bundle.zip -d /config/Library/Application\ Support/Plex\ Media\ Server/Plug-ins/ \
  ;
