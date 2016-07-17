FROM ubuntu
MAINTAINER ryanfox1985 <wolf.fox1985@gmail.com>

COPY CCcam.x86_64 /bin/CCcam
RUN chmod +x /bin/CCcam

EXPOSE 12000
EXPOSE 16000
EXPOSE 16001

ENTRYPOINT ["/bin/CCcam", "-d", "-C", "/config/CCcam/config/CCcam.cfg"]
