FROM debian:stretch-slim as build

MAINTAINER Alexey Koshkin <alexeyko@gmail.com>

RUN apt-get update

# Install Dependencies
RUN wget --no-check-certificate -O - https://files.freeswitch.org/repo/deb/freeswitch-1.8/fsstretch-archive-keyring.asc | apt-key add -
RUN echo "deb http://files.freeswitch.org/repo/deb/freeswitch-1.8/ stretch main" > /etc/apt/sources.list.d/freeswitch.list
RUN apt-get -y -qq install --quiet --no-install-recommends wget curl git automake autoconf libtool libtool-bin build-essential pkg-config zlib1g-dev libjpeg-dev sqlite3 libsqlite3-dev libcurl4-gnutls-dev libpcre3-dev libspeex-dev libspeexdsp-dev libedit-dev libssl-dev yasm libopus-dev libsndfile-dev libshout3-dev libtiff5-dev libmpg123-dev libmp3lame-dev libv8fs-6.1-dev ca-certificates
RUN apt-get update

# Download FreeSWITCH
WORKDIR /usr/local/src
ENV GIT_SSL_NO_VERIFY=1
RUN git clone https://freeswitch.org/stash/scm/fs/freeswitch.git -bv1.8.2 freeswitch

# Bootstrap the build.
WORKDIR freeswitch
RUN ./bootstrap.sh -j

# Enable the desired modules.
COPY ./modules.conf /usr/local/src/freeswitch/modules.conf

# Build FreeSWITCH.
RUN ./configure
RUN make
RUN make install
RUN make clean

WORKDIR /usr/local/freeswitch

RUN apt-get purge -y g++ \
&& apt-get autoremove -y \
&& rm -rf conf htdocs fonts grammar scripts images log/xml_cdr
&& rm -r /var/lib/apt/lists/* \
&& rm -rf /tmp/*
ADD conf.tar.gz .

RUN groupadd -r freeswitch && useradd -r -g freeswitch freeswitch.
RUN chown -R freeswitch:freeswitch /usr/local/freeswitch

# This results in a single layer image
FROM debian:stretch-slim
COPY --from=build /usr/local/freeswitch /usr/local/freeswitch
VOLUME ["/usr/local/freeswitch/log","/usr/local/freeswitch/recordings","/usr/local/freeswitch/conf"]
ENV PATH="/usr/local/freeswitch/bin:${PATH}"

CMD ["freeswitch", "-u", "freeswitch", "-g", "freeswitch", "-nonat"]