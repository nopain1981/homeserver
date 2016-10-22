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
docker images | awk {'print $3'} | xargs docker rmi -f

./compile.and.create.sh ark 1234:1234
./compile.and.create.sh couchpotato 5050:5050
./compile.and.create.sh headphones 5053:5053
./compile.and.create.sh jd2 8080:8080
./compile.and.create.sh noip 1234:1234
./compile.and.create.sh oscam 1337:1337
./compile.and.create.sh plex 32400:32400
./compile.and.create.sh plexpy 8181:8181
./compile.and.create.sh sabnzbd 5051:5051
#./compile.and.create.sh sickbeard 5055:5055
./compile.and.create.sh sickrage 5055:5055
./compile.and.create.sh sonarr 8989:8989
./compile.and.create.sh tvheadend 9981:9981
