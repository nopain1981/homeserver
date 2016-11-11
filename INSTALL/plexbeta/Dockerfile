FROM ubuntu:16.04 
MAINTAINER Tim Haak <tim@haak.co> 
ENV DEBIAN_FRONTEND="noninteractive" \ 
TERM="xterm" 
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
    echo "deb http://shell.ninthgate.se/packages/debian plexpass main" > /etc/apt/sources.list.d/plexmediaserver.list && \
    curl http://shell.ninthgate.se/packages/shell.ninthgate.se.gpg.key | apt-key add - && \
apt-get -q update && \
    rm /etc/apt/sources.list.d/plexmediaserver.list && \
    curl https://downloads.plex.tv/plex-media-server/1.2.7.2987-1bef33a/plexmediaserver_1.2.7.2987-1bef33a_amd64.deb -o /tmp/plex.deb && \
   apt-get -qy install avahi-daemon avahi-utils && \
    dpkg -i /tmp/plex.deb && \
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

