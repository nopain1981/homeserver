#/bin/bash
# this script supports the drop and recreate of all docker containers & images
# process: 
# 1) kill current running container & rm the container
# 2) remove the old image
# 3) recreate the image and build container
#
#------------------------------------------
# check if any docker exists > 
#cc=`docker ps -a | grep -v 'CONTAINER\|_config\|_data\|_run' | wc -l`
# kill and rm all containers
#if [ $cc != 0 ]; then
#docker ps -a | grep -v 'CONTAINER\|_config\|_data\|_run' | cut -c-12 | xargs docker kill
#docker ps -a | grep -v 'CONTAINER\|_config\|_data\|_run' | cut -c-12 | xargs docker rm
# rmi all docker images 
#docker images | grep '<none>' | grep -P '[1234567890abcdef]{12}' -o | xargs -L1 docker rmi
#fi
docker ps -a | awk {'print $1'} | xargs docker kill
docker ps -a | awk {'print $1'} | xargs docker rm
#docker images | awk {'print $3'} | xargs docker rmi -f

CCSH=/playground/homeserver/INSTALL/compile.and.create.sh

$CCSH ark 1234:1234
$CCSH couchpotato 5050:5050
$CCSH headphones 5053:5053
$CCSH jd2 8080:8080
$CCSH noip 1234:1234
$CCSH oscam 1337:1337
$CCSH plex 32400:32400
$CCSH plexpy 8181:8181
$CCSH sabnzbd 5051:5051
#$CCSH sickbeard 5055:5055
$CCSH sickrage 5055:5055
$CCSH sonarr 8989:8989
$CCSH tvheadend 9981:9981
