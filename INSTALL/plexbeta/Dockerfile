FROM ubuntu:16.04 
MAINTAINER Tim Haak <tim@haak.co> 
ENV DEBIAN_FRONTEND="noninteractive" \ 
TERM="xterm" 
# package version
ENV PLEX_INSTALL="https://plex.tv/downloads/latest/1?channel=8&build=linux-ubuntu-x86_64&distro=ubuntu"

# global environment settings
ENV DEBIAN_FRONTEND="noninteractive"
ENV HOME="/config"
ENV PLEX_DOWNLOAD="https://downloads.plex.tv/plex-media-server"

RUN echo "force-unsafe-io" > /etc/dpkg/dpkg.cfg.d/02apt-speedup &&\
    echo "Acquire::http {No-Cache=True;};" > /etc/apt/apt.conf.d/no-cache && \
    apt-get -q update && \
    apt-get -qy dist-upgrade && \
    apt-get install -qy \
      iproute2 \
      ca-certificates \
      openssl \
      xmlstarlet \
      curl \
      sudo \
    && \
apt-get -q update && \
   apt-get -qy install avahi-daemon avahi-utils && \
# install plex
 curl -o \
	/tmp/plexmediaserver.deb -L \
	"${PLEX_INSTALL}" && \
 dpkg -i /tmp/plexmediaserver.deb && \
    apt-get -y autoremove && \
    apt-get -y clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/*
VOLUME ["/config","/data"]
ENV RUN_AS_ROOT="true" \ 
CHANGE_DIR_RIGHTS="false" \ 
CHANGE_CONFIG_DIR_OWNERSHIP="true" \ 
HOME="/config" \ 
PLEX_DISABLE_SECURITY=1 

EXPOSE 33400 

ADD ./Preferences.xml /Preferences.xml

RUN ls -l /
ADD ./start.sh /start.sh
RUN chmod +x /start.sh

CMD ["/start.sh"]

