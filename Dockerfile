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
    && chown -R freeswitch:freeswitch /var/cache/freeswitch /etc/freeswitch/ /var/lib/freeswitch/ 

# Copy the configuration files
COPY ./conf/* /etc/freeswitch/

VOLUME ["/var/log/freeswitch/","/var/lib/freeswitch/recordings/","/etc/freeswitch/"]

CMD ["/usr/bin/freeswitch", "-c", "-u", "freeswitch", "-g", "freeswitch", "-nonat"]
