FROM phusion/baseimage:0.9.11
MAINTAINER needo <needo@superhero.org>
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
RUN apt-get install -qy python 
RUN apt-get install -qy  \
				build-essential libpcsclite-dev libssl-dev libusb-dev libusb-1.0 openssl subversion \
				libpcsclite1 \
				pcscd pcsc-tools git \
				usbutils

# Install headphones v0.3.4
RUN mkdir /opt/headphones
#RUN wget -P /tmp/ https://github.com/rembo10/headphones/archive/v0.3.4.tar.gz
#RUN tar -C /opt/headphones -xvf /tmp/v0.3.4.tar.gz --strip-components 1
RUN cd /opt && \
export GIT_SSL_NO_VERIFY=1 && git clone https://github.com/rembo10/headphones.git 
RUN chown swuser:swuser /opt/headphones

EXPOSE 8181

# headphones Configuration
VOLUME /config

# Downloads directory
VOLUME /downloads

# Music directory
VOLUME /music

# Add edge.sh to execute during container startup
RUN mkdir -p /etc/my_init.d
ADD edge.sh /etc/my_init.d/edge.sh
RUN chmod +x /etc/my_init.d/edge.sh

# Add headphones to runit
RUN mkdir /etc/service/headphones
ADD headphones.sh /etc/service/headphones/run
RUN chmod +x /etc/service/headphones/run
