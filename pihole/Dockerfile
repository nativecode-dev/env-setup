FROM diginc/pi-hole:latest

WORKDIR /etc/pihole-youtube

RUN set -ex \
  && export TERM=dumb \
  #############################################################################
  # PACKAGES
  #############################################################################
  && apt-get -qq update > /dev/null \
  && apt-get -qq upgrade -y > /dev/null \
  && apt-get -qq install -y python-pip > /dev/null \
  && apt-get -qq autoremove -y > /dev/null \
  && apt-get -qq autoclean -y > /dev/null \
  ;

COPY scripts/dnsdumpster.py ./dnsdumpster/youtube.py
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
