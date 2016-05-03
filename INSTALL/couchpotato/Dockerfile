FROM debian:8
MAINTAINER Dominique Barton

#
# Create user and group for CouchPotato.
#

RUN groupadd -r -g 50000 swuser \
    && useradd -r -u 50000 -g 50000 -d /home/swuser swuser

#
# Add CouchPotato init script.
#

ADD couchpotato.sh /couchpotato.sh
RUN chmod 755 /couchpotato.sh

#
# Install CouchPotato and all required dependencies.
#

RUN export VERSION=3.0.1 \
    && apt-get -q update \
    && apt-get install -qy curl ca-certificates python-pip python-dev libz-dev libxml2-dev libxslt1-dev gcc python3-lxml git subversion libffi-dev \
#    && curl -o /tmp/couchpotato.tar.gz https://codeload.github.com/CouchPotato/CouchPotatoServer/tar.gz/build/${VERSION} \
#    && tar xzf /tmp/couchpotato.tar.gz \
    && git clone https://github.com/CouchPotato/CouchPotatoServer.git /tmp/CouchPotatoServer \
    && mv /tmp/CouchPotatoServer* couchpotato \
    && chown -R swuser: couchpotato \
    && pip install `pip freeze -l | cut --fields=1 -d = -` --upgrade \
    && apt-get -y remove curl python-dev libz-dev libxml2-dev libxslt1-dev gcc \
    && apt-get -y autoremove \
    && apt-get -y clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/* 

#
# Define container settings.
#

VOLUME ["/datadir", "/download"]

EXPOSE 5050

#
# Start CouchPotato.
#

WORKDIR /couchpotato
CMD ["/couchpotato.sh"]
