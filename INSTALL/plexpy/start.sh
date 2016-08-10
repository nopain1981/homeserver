#!/bin/bash
# If debug mode, then enable xtrace
if [ "${DEBUG,,}" = "true" ]; then
  set -x
fi

# Set the defaults
RUN_AS_ROOT=${RUN_AS_ROOT:-false}
CHANGE_DIR_RIGHTS=${CHANGE_DIR_RIGHTS:-true}
CHANGE_CONFIG_DIR_OWNERSHIP=${CHANGE_CONFIG_DIR_OWNERSHIP:-true}

GROUP=swuser
mkdir -p /config/logs/supervisor

touch /supervisord.log
touch /supervisord.pid

# Get the proper group membership, credit to http://stackoverflow.com/a/28596874/249107

TARGET_GID=$(stat -c "%g" /config)
EXISTS=$(cat /etc/group | grep "${TARGET_GID}" | wc -l)

# Create new group using target GID and add plex user
if [ "$EXISTS" = "0" ]; then
  groupadd --gid ${TARGET_GID} "${GROUP}"
  useradd -g "${GROUP}" -u 50000 swuser
else
  # GID exists, find group name and add
  GROUP=$(getent group "$TARGET_GID" | cut -d: -f1)
  useradd -g "${GROUP}" -u 50000 swuser
  usermod -a -G "${GROUP}" swuser
fi
chown swuser: /supervisord.log /supervisord.pid
usermod -a -G "${GROUP}" swuser

if [[ -n "${SKIP_CHOWN_CONFIG}" ]]; then
  CHANGE_CONFIG_DIR_OWNERSHIP=false
fi

if [ "${CHANGE_CONFIG_DIR_OWNERSHIP,,}" = "true" ]; then
  find /config ! -user swuser -print0 | xargs -0 -I{} chown -R swuser: {}
fi

# Will change all files in directory to be readable by group
if [ "${CHANGE_DIR_RIGHTS,,}" = "true" ]; then
  chgrp -R "${GROUP}" /data
  chmod -R g+rX /data
fi


# Current defaults to run as root while testing.
#if [ "${RUN_AS_ROOT,,}" = "true" ]; then
#  /usr/sbin/start_pms
#else
  sudo -u swuser -E sh -c "python /opt/plexpy/PlexPy.py --datadir /config"
#fi
