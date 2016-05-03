FROM timhaak/base:latest
#
# Create user and group for sabnzbd.
#

RUN groupadd -r -g 50000 swuser \
    && useradd -r -u 50000 -g 50000 -d /home/swuser swuser

#
# Add sabnzbd init script.
#

ADD sabnzbd.sh /sabnzbd.sh
RUN chmod 755 /sabnzbd.sh

#
# Install sabnzbd and all required dependencies.
#

RUN add-apt-repository -y  ppa:jcfp/ppa && \
    apt-get -q update && \
    apt-get install -qy --force-yes  sabnzbdplus sabnzbdplus-theme-classic sabnzbdplus-theme-mobile sabnzbdplus-theme-plush \
    par2 python-yenc unzip unrar && \
    apt-get -y autoremove && \
    apt-get -y clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/*

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