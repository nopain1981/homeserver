FROM debian:8 
MAINTAINER Dominique Barton 
# 
# Create user and group for plexpy. 
# 
RUN groupadd -r -g 50000 swuser \
    && useradd -r -u 50000 -g 50000 -d /home/swuser swuser

# 
# Add plexpy init script. 
# 
ADD plexpy.sh /plexpy.sh
RUN chmod 755 /plexpy.sh

# 
# Install plexpy and all required dependencies. 
# 
RUN export VERSION=3.0.1 \
    && apt-get -q update \
    && apt-get install -qy curl ca-certificates python-pip python-dev libz-dev libxml2-dev libxslt1-dev gcc python3-lxml git subversion libffi-dev \
    && git clone https://github.com/drzoidberg33/plexpy.git /tmp/plexpy \
    && mv /tmp/plexpy* plexpy \
    && chown -R swuser: plexpy \
    && pip install `pip freeze -l | cut --fields=1 -d = -` --upgrade
RUN apt-get -y remove curl python-dev libz-dev libxml2-dev libxslt1-dev gcc \
    && apt-get -y autoremove \
    && apt-get -y clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/* 

#
# Define container settings.
#

VOLUME ["/config","/data"]

EXPOSE 8181 8181

#
# Start plexpy.
#

WORKDIR /plexpy
CMD ["/plexpy.sh"]