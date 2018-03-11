# STAGE: BUILD
###############################################################################
FROM diginc/pi-hole:latest AS BUILD
# Copy install script.
COPY scripts/youtube-install.sh /etc/pihole/youtube-install.sh
# Run the install script.
RUN set -ex \
  # Upgrade packages in our environment.
  && apt-get update \
  && apt-get upgrade -y \
  # Install PIP.
  && apt-get install -y python-pip \
  # Clean up unneeded packages.
  && apt-get autoremove -y \
  && apt-get autoclean -y \
  # Run the YouTube add blocking install.
  && sh /etc/pihole/youtube-install.sh \
  ;

# STAGE: FINAL
###############################################################################
FROM diginc/pi-hole:latest
COPY --from=BUILD /etc/dnsdumpster /etc/dnsdumpster
COPY --from=BUILD /etc/pihole /etc/pihole
COPY --from=BUILD /var/www/html /var/www/html

ENV ServerIP="127.0.0.1"

COPY scripts/cron-install.sh /etc/pihole/cron-install.sh

RUN set -ex \
  # Upgrade packages in our environment.
  && apt-get update \
  && apt-get upgrade -y \
  # Install the cron jobs.
  && crontab /etc/pihole/cron.youtube \
  # Make files executable.
  && chmod +x /etc/pihole/youtube-ads.sh \
  ;
