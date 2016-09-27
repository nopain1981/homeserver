FROM debian:8
MAINTAINER Dominique Barton

#
# Create user and group for SABnzbd.
#

RUN groupadd -r -g 50000 swuser \
    && useradd -r -u 50000 -g 50000 -d /swuser swuser

#
# Add SickBeard init script.
#

ADD sickbeard.sh /sickbeard.sh
RUN chmod 755 /sickbeard.sh

#
# Install SickBeard and all required dependencies.
#

RUN export VERSION=master \
    && apt-get -q update \
    && apt-get install -qy curl ca-certificates python-cheetah python-openssl \
    && curl -o /tmp/sickbeard.tar.gz https://codeload.github.com/midgetspy/Sick-Beard/tar.gz/${VERSION} \
    && tar xzf /tmp/sickbeard.tar.gz \
    && mv Sick-Beard-* sickbeard \
    && chown -R swuser: sickbeard \
    && apt-get -y remove curl \
    && apt-get -y autoremove \
    && apt-get -y clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/*

#
# Define container settings.
#

VOLUME ["/datadir", "/media"]

EXPOSE 8081

#
# Start SickBeard.
#

WORKDIR /sickbeard

CMD ["/sickbeard.sh"]
