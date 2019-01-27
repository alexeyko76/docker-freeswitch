FROM debian:stretch-slim

MAINTAINER Alexey Koshkin <alexeyko@gmail.com>

# Add FreeSWITCH 1.8 repo & install dependencies

RUN export DEBIAN_FRONTEND=noninteractive && apt-get update -qq && apt-get -y -qq install --quiet --no-install-recommends wget git curl apt-transport-https ca-certificates pkg-config gnupg \
    && echo 'deb http://files.freeswitch.org/repo/deb/freeswitch-1.8/ stretch main' > /etc/apt/sources.list.d/freeswitch.list \
    && wget --no-check-certificate -O - https://files.freeswitch.org/repo/deb/freeswitch-1.8/fsstretch-archive-keyring.asc | apt-key add - \
    && apt-get update -qq \
    && apt-get -y -qq install --quiet --no-install-recommends freeswitch \
        freeswitch-mod-vlc \
        freeswitch-mod-v8 \
        freeswitch-mod-sofia \
        freeswitch-mod-sndfile \
        freeswitch-mod-shout \
        freeswitch-mod-opus \
        freeswitch-mod-native-file \
        freeswitch-mod-loopback \
        freeswitch-mod-http-cache \
        freeswitch-mod-g723-1 \
        freeswitch-mod-fail2ban \
        freeswitch-mod-event-socket \
        freeswitch-mod-dptools \
        freeswitch-mod-console \
        freeswitch-mod-commands \
        freeswitch-mod-b64 \
        freeswitch-mod-amr \
        freeswitch-mod-amrwb \
    && apt-get purge -qq -y --auto-remove git \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir /var/cache/freeswitch \
    && chown -R freeswitch:freeswitch /var/{cache,lib,run}/freeswitch /etc/freeswitch/

# Copy the configuration files
COPY ./conf/* /etc/

VOLUME ["/var/log/freeswitch/","/var/lib/freeswitch/recordings/","/etc/freeswitch/"]

# Healthcheck to make sure the service is running
SHELL ["/bin/bash"]
HEALTHCHECK --interval=60s --timeout=15s CMD /usr/bin/fs_cli -x status | grep -q ^UP || exit 1

CMD ["/usr/bin/freeswitch", "-c", "-u", "freeswitch", "-g", "freeswitch", "-nonat"]
