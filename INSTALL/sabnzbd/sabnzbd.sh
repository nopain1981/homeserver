#!/bin/bash
set -e

#
# Display settings on standard out.
#

USER="swuser"

echo "SABNZBD settings"
echo "===================="
echo
echo "  User:       ${USER}"
echo "  UID:        ${CP_UID:=50000}"
echo "  GID:        ${CP_GID:=50000}"
echo
echo "  Config:     ${CONFIG:=/config/sabnzbd.ini}"
echo

#
# Change UID / GID of SABNZBD user.
#

printf "Updating UID / GID... "
[[ $(id -u ${USER}) == ${CP_UID} ]] || usermod  -o -u ${CP_UID} ${USER}
[[ $(id -g ${USER}) == ${CP_GID} ]] || groupmod -o -g ${CP_GID} ${USER}
echo "[DONE]"

#
# Set directory permissions.
#

printf "Set permissions... "
#touch ${CONFIG}
chown -R ${USER}: /sabnzbd /tmp
chown -R ${USER}: $(dirname ${CONFIG})
echo "[DONE]"

#
# Finally, start SABNZBD.
#

CONFIG=${CONFIG:-/config/sabnzbd.ini}
echo "Starting Sabnzbd..."
exec su -pc "/usr/bin/sabnzbdplus --config-file ${CONFIG} --console --server 0.0.0.0:5051" ${USER}