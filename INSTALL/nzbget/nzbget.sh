#!/bin/bash
#
# Display settings on standard out.
#

USER="swuser"

echo "nzbget settings"
echo "===================="
echo
echo "  User:       ${USER}"
echo "  UID:        ${CP_UID:=50000}"
echo "  GID:        ${CP_GID:=50000}"
echo
echo "  Config:     ${CONFIG:=/config/nzbget.ini}"
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
chown -R ${USER}: /nzbget /tmp
chown -R ${USER}: $(dirname ${CONFIG})
echo "[DONE]"

exec su -pc "nzbget -D -c /config/nzbget.conf" ${USER}