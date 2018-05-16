FROM diginc/pi-hole:latest

ENV DEBIAN_FRONTEND=noninteractive
ENV RATE_RELOAD=10
ENV RATE_UPDATE=1

WORKDIR /etc/pihole-youtube

COPY scripts/env.sh ./env.sh
COPY scripts/install.sh ./install.sh
COPY scripts/updater.sh ./updater.sh

RUN set -ex \
  && export TERM=dumb \
  #############################################################################
  # PACKAGES
  #############################################################################
  && apt-get update \
  && apt-get upgrade -y \
  && apt-get autoremove -y \
  && apt-get autoclean -y \
  #############################################################################
  # APPLICATION
  #############################################################################
  && chmod +x ./env.sh \
  && chmod +x ./install.sh \
  && chmod +x ./updater.sh \
  # Run the YouTube add blocking install.
  && ./install.sh \
  ;

WORKDIR /etc/pihole
