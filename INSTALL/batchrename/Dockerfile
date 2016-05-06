FROM phusion/baseimage:0.9.18
MAINTAINER tobbenb <torbjornbrekke@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

# Set correct environment variables
ENV HOME /root

# Use baseimage-docker's init system
CMD ["/sbin/my_init"]

# Fix a Debianism of the nobody's uid being 65534
RUN groupadd -r -g 50000 swuser \
    && useradd -r -u 50000 -g 50000 -d /home/swuser swuser

RUN apt-get update -q

# Install Dependencies
RUN \
 locale-gen en_US.UTF-8 &&\
 update-locale LANG=en_US.UTF-8 &&\
 apt-get update &&\
 apt-get -y install software-properties-common &&\
 # ffmpeg ppa
 add-apt-repository -y ppa:mc3man/trusty-media &&\
add-apt-repository ppa:graphics-drivers/ppa &&\
 rm -rf /var/lib/apt/lists/* 
RUN \
    # install required libraries
 apt-get update &&\
 apt-get -y install\
 curl\
 ffmpeg\
 mediainfo\
 php5-cli\
 php5-fpm

RUN apt-get update && apt-get install -q -y \
  wget \
  build-essential 

RUN mkdir /opt/batchconv
RUN cd /opt 
RUN chown swuser:swuser /opt/batchconv

EXPOSE 8181

# Configuration
VOLUME /config

# Downloads directory
VOLUME /downloads

# Music directory
VOLUME /music

#Add converter files
ADD ./batchconv/ /opt/batchconv
RUN chmod +x /opt/batchconv/batch-h264-converter

# Add batchconverter to runit
RUN mkdir -p /etc/service/batchrename
ADD batchrename.sh /etc/service/batchrename/run
RUN chmod +x /etc/service/batchrename/run
