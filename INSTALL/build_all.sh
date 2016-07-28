#/bin/bash
# this script supports the drop and recreate of all docker containers & images
# process: 
# 1) kill current running container & rm the container
# 2) remove the old image
# 3) recreate the image and build container
#
#------------------------------------------
# lets start with couchpotato
for cc in `docker ps -a | awk {'print $2'} | grep -v ID`;
do
docker kill $cc && docker rm $cc
docker rmi -f $cc
done
./compile.and.create.sh couchpotato 5050:5050
./compile.and.create.sh headphones 5053:5053
./compile.and.create.sh oscam 16999:16999
./compile.and.create.sh plex 32400:32400
./compile.and.create.sh sabnzbd 5051:5051
./compile.and.create.sh sonarr 8989:8989
./compile.and.create.sh tvheadend 9981:9981
./compile.and.create.sh batchrename 8080:8080
#./compile.and.create.sh batchrename 6789:6789
./compile.and.create.sh noip 1234:1234
