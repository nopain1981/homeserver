#!/bin/bash -x


# Set the uid:gid to run as
[ "$sonarr_uid" ] && usermod  -o -u "$sonarr_uid" swuser
[ "$sonarr_gid" ] && groupmod -o -g "$sonarr_gid" swuser


# Set folder permissions
chown -R swuser:swuser/opt/NzbDrone /config

# chown -r the /media folder only if owned by root. We asume that means it's a docker volume
[ "$(stat -c %u:%g /media)" = "0:0" ] && chown swuser:swuser /media


# Disable the logfile on disk (because we have docker logs instead)
_sonarr_logfile="/config/logs/nzbdrone.txt"
mkdir -p "/config/logs"
ln -sf /dev/null $_sonarr_logfile


# Make sure the .pid file doesn't exist
_sonarr_pid_file="/config/nzbdrone.pid"
rm -f "$_sonarr_pid_file"


# Start the sonarr daemon. web UI should bind to * automatically
sudo -E su "swuser" << EOF
	set -x
	mono /opt/NzbDrone/NzbDrone.exe -data=/config
EOF




