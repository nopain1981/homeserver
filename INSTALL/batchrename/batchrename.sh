#!/bin/bash
set -e

#
# Display settings on standard out.
#

USER="swuser"

echo "Batchrename settings"
echo "===================="
echo
echo "  User:       ${USER}"
echo "  UID:        ${CP_UID:=50000}"
echo "  GID:        ${CP_GID:=50000}"
echo
echo "  MoviePath:     ${CONFIG:=/config/config.ini}"
echo

#
# Change UID / GID of Batchrename user.
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
chown -R ${USER}: /tmp
chown ${USER}: $(dirname ${CONFIG})
echo "[DONE]"

#
# Finally, start CouchPotato.
#

CONFIG=${CONFIG:-/config/config.ini}
echo "Starting Batchrename..."
exec su -pc "/opt/batchconv/batch-h264-converter /storage/data/Library/Movies >> /tmp/batchconv.log" ${USER}

