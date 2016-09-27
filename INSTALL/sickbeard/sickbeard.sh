#!/bin/bash
set -e

#
# Display settings on standard out.
#

USER="swuser"

echo "SickBeard settings"
echo "=================="
echo
echo "  User:       ${USER}"
echo "  UID:        ${SICKBEARD_UID:=50000}"
echo "  GID:        ${SICKBEARD_GID:=50000}"
echo
echo "  Config:     ${CONFIG:=/config/config.ini}"
echo

#
# Change UID / GID of SickBeard user.
#

printf "Updating UID / GID... "
[[ $(id -u ${USER}) == ${SICKBEARD_UID} ]] || usermod  -o -u ${SICKBEARD_UID} ${USER}
[[ $(id -g ${USER}) == ${SICKBEARD_GID} ]] || groupmod -o -g ${SICKBEARD_GID} ${USER}
echo "[DONE]"

#
# Set directory permissions.
#

printf "Set permissions... "
touch ${CONFIG}
chown -R ${USER}: /sickbeard
chown ${USER}: /datadir /media $(dirname ${CONFIG})
chown -R swuser:swuser /config
echo "[DONE]"

#
# Finally, start SickBeard.
#

echo "Starting SickBeard..."
exec su -pc "./SickBeard.py --nolaunch -p 5055 --datadir=$(dirname ${CONFIG}) --config=${CONFIG}" ${USER}
