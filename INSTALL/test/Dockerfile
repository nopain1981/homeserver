FROM debian:8
MAINTAINER Dominique Barton
#

RUN export VERSION=3.0.1 \
    && apt-get -q update \
    && apt-get install -qy curl ca-certificates python-pip python-dev libz-dev libxml2-dev libxslt1-dev gcc python3-lxml git subversion libffi-dev \
    && pip install `pip freeze -l | cut --fields=1 -d = -` --upgrade \
    && apt-get -qy install \
        apt-transport-https ca-certificates \
    && apt-get -y remove curl python-dev libz-dev libxml2-dev libxslt1-dev gcc \
    && apt-get -y autoremove \
    && apt-get -y clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/*

RUN echo deb https://apt.dockerproject.org/repo debian-jessie main > /etc/apt/sources.list.d/docker.list

RUN apt-get update \
    && apt-cache policy docker-engine \
    && apt-get -y --force-yes install docker-engine && service docker start \
    && echo "done"

#
# Define container settings.
#

VOLUME ["/datadir", "/download"]

EXPOSE 5050


