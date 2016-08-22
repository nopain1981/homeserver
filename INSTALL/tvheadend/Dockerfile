FROM ubuntu:16.04

# Choose from: master, unstable, testing, or stable
ENV HTS_COMMIT master

ENV _clean="rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*"
ENV _apt_clean="eval apt-get clean && $_clean"

# Install s6-overlay
ENV s6_overlay_version="1.17.1.1"
ADD https://github.com/just-containers/s6-overlay/releases/download/v${s6_overlay_version}/s6-overlay-amd64.tar.gz /tmp/
RUN tar zxf /tmp/s6-overlay-amd64.tar.gz -C / && $_clean
ENV S6_LOGGING="1"
# ENV S6_KILL_GRACETIME="3000"

# Install pipework
ADD https://github.com/jpetazzo/pipework/archive/master.tar.gz /tmp/pipework-master.tar.gz
RUN tar -zxf /tmp/pipework-master.tar.gz -C /tmp && cp /tmp/pipework-master/pipework /sbin/ && $_clean

# Install xmltv & tvheadend
RUN apt-get update -qq && apt-get install -qqy apt-transport-https ffmpeg \
 && apt-get update -qq && apt-get install -qqy bzip2 libavahi-client3 xmltv \
 && apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get install -qqy udev \
    wget git curl make dkms dpkg-dev python \
    debconf-utils software-properties-common \
    build-essential hdhomerun-config libhdhomerun-dev debhelper libswscale-dev \
    libavahi-client-dev libavformat-dev libavcodec-dev liburiparser-dev \
    libssl-dev libiconv-hook1 libiconv-hook-dev cmake \
 && rm -rf /home/hts && $_apt_clean

RUN git clone https://github.com/tvheadend/tvheadend.git /srv/tvheadend \
  && cd /srv/tvheadend && git checkout ${HTS_COMMIT} && ./configure --libffmpeg_static && make && make install


# Relocate the timezone file
RUN mkdir -p /config/.etc && mv /etc/timezone /config/.etc/ && ln -s /config/.etc/timezone /etc/

# Set locale
ENV LANG="en_US.UTF-8"

RUN apt-get update -qqy && apt-get install -qqy locales && $_apt_clean \
 && grep "$LANG" /usr/share/i18n/SUPPORTED >> /etc/locale.gen && locale-gen \
 && update-locale LANG=$LANG

# Relocate the locale files in /usr/lib/locale/
RUN mkdir -p /config/.link/usr/lib/ /config/.link/etc \
 && mv /usr/lib/locale /config/.link/usr/lib/ \
 && mv /etc/locale.gen /config/.link/etc \
 && ln -s /config/.link/usr/lib/locale /usr/lib/ \
 && ln -s /config/.link/etc/locale.gen /etc/


# Global config
ADD config/backup/unknown.tar.bz2+ /config/
ADD config/dvr/recordings+ /config/
ADD config/users/admin+ /config/
# Configure the hts user account and it's folders
RUN groupadd -o -g 50000 swuser \
 && useradd -o -c "User used for tvheadend" \
   -u 50000 -N -g swuser --shell /bin/sh -d /config swuser \
 && usermod -o -u 50000 -a -G video -d /config swuser \
 && install -o swuser -g swuser -d /config /recordings

# Launch script
ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh


# Default container settings
VOLUME /config /recordings
EXPOSE 9981 9982 65001 5002 5004 5000
ENTRYPOINT ["/init","/entrypoint.sh","-u","swuser","-g","swuser","--noacl","-c","/config"]
