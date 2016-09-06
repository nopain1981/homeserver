#!/bin/bash

function stopJD2 {
	PID=$(cat JDownloader.pid)
	kill $PID
	wait $PID
	exit
}

USER="swuser"

echo "JD2 settings"
echo "===================="
echo
echo "  User:       ${USER}"
echo "  UID:        ${CP_UID:=50000}"
echo "  GID:        ${CP_GID:=50000}"
echo
echo "  Config:     ${CONFIG:=/config/config.ini}"
echo

# Set the uid:gid to run as
[ "$jd_uid" ] && usermod  -o -u "$jd_uid" swuser
[ "$jd_gid" ] && groupmod -o -g "$jd_gid" swuser

# Set folder permissions
chown -R swuser:swuser /opt/JDownloader /config

trap stopJD2 EXIT

exec su -pc "java -Djava.awt.headless=true -jar /opt/JDownloader/JDownloader.jar" ${USER} &
#java -Djava.awt.headless=true -jar /opt/JDownloader/JDownloader.jar &

while true; do
	sleep inf
done

