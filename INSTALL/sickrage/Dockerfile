FROM alpine:3.4
MAINTAINER Technosoft2000 <technosoft2000@gmx.net> 

# Set basic environment settings

ENV \
    # - TERM: The name of a terminal information file from /lib/terminfo, 
    # this file instructs terminal programs how to achieve things such as displaying color.
    TERM="xterm" \

    # - LANG, LANGUAGE, LC_ALL: language dependent settings (Default: de_DE.UTF-8)
    LANG="de_DE.UTF-8" \
    LANGUAGE="de_DE:de" \
    LC_ALL="de_DE.UTF-8" \

    # - PKG_*: the needed applications for installation
    GOSU_VERSION="1.9" \
    PKG_BASE="bash tzdata git" \
    PKG_DEV="make gcc g++ python-dev openssl-dev libffi-dev" \
    PKG_PYTHON="ca-certificates py-pip python py-libxml2 py-lxml" \
    PKG_COMPRESS="unrar" \
    
    # - SET_CONTAINER_TIMEZONE: set this environment variable to true to set timezone on container startup
    SET_CONTAINER_TIMEZONE="true" \

    # - CONTAINER_TIMEZONE: UTC, Default container timezone as found under the directory /usr/share/zoneinfo/
    CONTAINER_TIMEZONE="Europe/Berlin" \

    # - SR_HOME: SickRage Home directory
    SR_HOME="/sickrage" \

    # - SR_REPO, SR_BRANCH: SickRage GitHub repository and related branch
#    SR_REPO="https://github.com/cytec/SickRage.git" \
#    SR_BRANCH="master" \
    SR_REPO="https://github.com/SiCKRAGETV/SiCKRAGE.git" \
    SR_BRANCH="master" \

    # - SYNO_VOLUME: Snyology NAS volume main directory
    SYNO_VOLUME="/volume1"    
	
RUN \
    # update the package list
    apk -U upgrade && \

    # install gosu from https://github.com/tianon/gosu
    set -x \
    && apk add --no-cache --virtual .gosu-deps \
        dpkg \
        gnupg \
        openssl \
    && dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')" \
    && wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch" \
    && wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch.asc" \
    && export GNUPGHOME="$(mktemp -d)" \
    && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
    && gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
    && rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc \
    && chmod +x /usr/local/bin/gosu \
    && gosu nobody true \
    && apk del .gosu-deps \
    && \

    # install the needed applications
    apk -U add --no-cache $PKG_BASE $PKG_DEV $PKG_PYTHON $PKG_COMPRESS && \

    # install additional python packages:
    # setuptools, pyopenssl, cheetah, requirements 
    pip --no-cache-dir install --upgrade setuptools && \
    pip --no-cache-dir install --upgrade pyopenssl cheetah requirements && \

    # remove not needed packages
    apk del $PKG_DEV && \

    # create Snyology NAS /volume1 folders 
    # to easily provide the same corresponding host directories at SickRage
    mkdir -p $SYNO_VOLUME/downloads && \
    mkdir -p $SYNO_VOLUME/video && \
    mkdir -p $SYNO_VOLUME/certificates && \

    # create SickRage folder structure
    mkdir -p $SR_HOME/app && \
    mkdir -p $SR_HOME/config && \
    mkdir -p $SR_HOME/data && \

    # cleanup temporary files
    rm -rf /tmp && \
    rm -rf /var/cache/apk/*

# set the working directory for SickRage
WORKDIR $SR_HOME/app

#start.sh will download the latest version of SickRage and run it.
COPY *.sh $SR_HOME/
RUN chmod u+x $SR_HOME/start.sh

# Set volumes for the SickRage folder structure
VOLUME $SR_HOME/config $SR_HOME/data $SYNO_VOLUME/downloads $SYNO_VOLUME/video $SYNO_VOLUME/certificates

# Expose ports
EXPOSE 8081

# Start SickRage-cytec
CMD ["/bin/bash", "-c", "$SR_HOME/start.sh"]
