FROM debian:8 
MAINTAINER Dominique Barton 
# 
# Create user and group for SABnzbd. 
# 
RUN groupadd -r -g 50000 swuser \
    && useradd -r -u 50000 -g 50000 -d /home/swuser swuser

# 
# Add SABnzbd init script. 
# 
ADD sabnzbd.sh /sabnzbd.sh
RUN chmod 755 /sabnzbd.sh

# 
# Install SABnzbd and all required dependencies. 
# 
RUN export SABNZBD_VERSION=1.1.0RC1 PAR2CMDLINE_VERSION=v0.6.14 \
    && sed -i "s/ main$/ main contrib non-free/" /etc/apt/sources.list \
    && apt-get -q update 
RUN apt-get install -qy curl ca-certificates python-cheetah python-openssl python-yenc unzip unrar p7zip-full build-essential automake
RUN curl -o /tmp/sabnzbd.tar.gz https://codeload.github.com/sabnzbd/sabnzbd/tar.gz/${SABNZBD_VERSION} \
    && tar xzf /tmp/sabnzbd.tar.gz \
    && mv sabnzbd-* sabnzbd \
    && chown -R swuser:swuser /tmp/sabnzbd* 
RUN curl -o /tmp/par2cmdline.tar.gz https://codeload.github.com/Parchive/par2cmdline/tar.gz/v0.6.14 \
    && tar xzf /tmp/par2cmdline.tar.gz -C /tmp \
    && cd /tmp/par2cmdline-* \
    && aclocal \
    && automake --add-missing \
    && autoconf \
    && ./configure \
    && make \
    && make install 
RUN apt-get -y remove curl build-essential automake \
    && apt-get -y autoremove \
    && apt-get -y clean \
    && rm -rf /var/lib/apt/lists/* \
    && cd / \
    && rm -rf /tmp/*
#
# Define container settings.
#

VOLUME ["/config","/data"]

EXPOSE 5051 9090

#
# Start sabnzbd.
#

WORKDIR /sabnzbd
CMD ["/sabnzbd.sh"]