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
      wget \
    && \
    apt-get -q update && \
    #apt-get install -qy plexmediaserver && \
    curl https://downloads.plex.tv/plex-media-server/1.2.3.2914-1ff0f18/plexmediaserver_1.2.3.2914-1ff0f18_amd64.deb -o /tmp/plex.deb && \ 
    dpkg -i /tmp/plex.deb && \
    apt-get -y autoremove && \
    apt-get -y clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/*
VOLUME ["/config","/data"]
ENV RUN_AS_ROOT="false" \ 
CHANGE_DIR_RIGHTS="true" \ 
CHANGE_CONFIG_DIR_OWNERSHIP="true" \ 
HOME="/config" \ 
PLEX_DISABLE_SECURITY=1 

EXPOSE 32400 

ADD ./Preferences.xml /Preferences.xml

RUN chmod -R 777 /config

ADD ./start.sh /start.sh
RUN chmod +x /start.sh

CMD ["/start.sh"]
