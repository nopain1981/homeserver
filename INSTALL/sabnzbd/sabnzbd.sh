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
# Because SABnzbd runs in a container we've to make sure we've a proper
# listener on 0.0.0.0. We also have to deal with the port which by default is
# 8080 but can be changed by the user.
#

printf "Get listener port... "
PORT=$(sed -n '/^port *=/{s/port *= *//p;q}' ${CONFIG})
LISTENER="-s 0.0.0.0:${PORT:=5051}"
echo "[${PORT}]"

#
# Finally, start SABnzbd.
#

echo "Starting SABnzbd..."
exec su -pc "./SABnzbd.py -b 0 -f ${CONFIG} ${LISTENER}" ${USER}