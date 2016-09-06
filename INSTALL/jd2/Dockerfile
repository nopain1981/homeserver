FROM java:jre

MAINTAINER PlusMinus <piddlpiddl@gmail.com>

# Setup sonarr /config dir and /media folder
RUN groupadd -o -g 50000 swuser \
 && useradd -o -c "Also known as ijd2 - runs java with jd2" \
    -u 50000 -N -g swuser --shell /bin/sh -d /config swuser \
 && install -o swuser -g swuser -d /config /media

# Create directory, downloader JD" and start JD2 for the initial update and creation of config files.
RUN \
	mkdir /opt/JDownloader/ && \
	wget -O /opt/JDownloader/JDownloader.jar --user-agent="https://hub.docker.com/r/plusminus/jdownloader2-headless/" --progress=bar:force http://installer.jdownloader.org/JDownloader.jar && \
	java -Djava.awt.headless=true -jar /opt/JDownloader/JDownloader.jar


RUN chown -R swuser:swuser /opt/JDownloader/

COPY startJD2.sh /opt/JDownloader/
RUN chmod +x /opt/JDownloader/startJD2.sh


# Run this when the container is started
CMD /opt/JDownloader/startJD2.sh
