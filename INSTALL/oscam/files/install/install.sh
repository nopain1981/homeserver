#!/bin/bash
set -e

#
# Display settings on standard out.
#

USER="swuser"

echo "oscam settings"
echo "===================="
echo
echo "  User:       ${USER}"
echo "  UID:        ${CP_UID:=50000}"
echo "  GID:        ${CP_GID:=50000}"
echo
echo "  Config:     ${CONFIG:=/config/oscam.conf}"
echo

#
# Change UID / GID of oscam user.
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
#chown -R ${USER}: $(dirname ${CONFIG})
echo "[DONE]"

#####################################
#	Install dependencies			#
#									#
#####################################

apt-get update -qq
apt-get install -qy  \
				build-essential libpcsclite-dev libssl-dev libusb-dev libusb-1.0 openssl subversion \
				libpcsclite1 \
				pcscd pcsc-tools git \
				usbutils
				
#####################################
#	Compile and install				#
#	oscam							#
#####################################
cd /tmp && \
export GIT_SSL_NO_VERIFY=1 && git clone https://github.com/gfto/oscam.git oscam-svn
pushd /tmp/oscam-svn 
./config.sh --enable all --disable HAVE_DVBAPI IPV6SUPPORT LCDSUPPORT LEDSUPPORT READ_SDT_CHARSETS CARDREADER_DB2COM CARDREADER_STAPI CARDREADER_STAPI5 CARDREADER_STINGER CARDREADER_INTERNAL CARDREADER_INTERNAL
make OSCAM_BIN=/usr/bin/oscam NO_PLUS_TARGET=1 CONF_DIR=/config pcsc-libusb
popd
 
#####################################
#	Add init scripts				#
#									#
#####################################
#
# Finally, start oscam .
#
mkdir -p /etc/service/oscam
cat <<'EOT' > /etc/service/oscam/run
#!/bin/bash
exec /sbin/setuser swuser /usr/bin/oscam
EOT
chmod +x /etc/service/oscam/run

mkdir -p /etc/service/pcscd
cat <<'EOT' > /etc/service/pcscd/run
#!/bin/bash
exec /usr/sbin/pcscd
EOT
chmod +x /etc/service/pcscd/run

#####################################
#	Remove unneeded packages		#
#									#
#####################################

apt-get purge -qq build-essential subversion g++ g++-4.8 libapr1 libaprutil1 libserf-1-1 libstdc++-4.8-dev libsvn1 && apt-get clean && rm -rf /var/lib/apt/lists/* /var/tmp/* /tmp/oscam-svn
