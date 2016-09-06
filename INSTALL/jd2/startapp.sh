umask 000
sudo -E su "swuser" << EOF
set -x
/config/jd2/JDownloader2
EOF
