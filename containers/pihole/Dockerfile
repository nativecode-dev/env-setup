FROM diginc/pi-hole:latest

ENV DEBIAN_FRONTEND=noninteractive
ENV RATE_RELOAD=10
ENV RATE_UPDATE=1

WORKDIR /etc/pihole-youtube

RUN set -ex \
  && export TERM=dumb \
  #############################################################################
  # PACKAGES
  #############################################################################
  && apt-get -qq update > /dev/null \
  && apt-get -qq upgrade -y > /dev/null \
  && apt-get -qq autoremove -y > /dev/null \
  && apt-get -qq autoclean -y > /dev/null \
  ;

COPY scripts/env.sh ./env.sh
COPY scripts/install.sh ./install.sh
COPY scripts/updater.sh ./updater.sh

RUN set -ex \
  #############################################################################
  # APPLICATION
  #############################################################################
  # Make scripts executable.
  && chmod +x ./env.sh \
  && chmod +x ./install.sh \
  && chmod +x ./updater.sh \
  # Run the YouTube add blocking install.
  && ./install.sh \
  ;

WORKDIR /etc/pihole
