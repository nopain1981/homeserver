FROM phusion/baseimage:0.9.18
MAINTAINER tobbenb <torbjornbrekke@gmail.com>

# Set correct environment variables.
ENV HOME="/root" DEBIAN_FRONTEND="noninteractive" TERM="xterm"

RUN groupadd -r -g 50000 swuser \
    && useradd -r -u 50000 -g 50000 -d /home/swuser swuser

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

#Add install files
ADD ./files/ /tmp/
ADD ./files/install/oscam /tmp/oscam

#Install application and remove install files after
RUN chmod +x /tmp/install/install.sh && sleep 1 && /tmp/install/install.sh && rm -r /tmp/install

RUN chmod +x /tmp/oscam && cp /tmp/oscam /usr/bin/oscam && chown swuser:swuser /usr/bin/oscam

EXPOSE 8888

VOLUME /config
