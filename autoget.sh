#/bin/bash
cd /playground/homeserver \
&& git fetch --all \
&& git reset --hard origin/master \
&& git pull origin master
echo "Last Refresh occoured: `date`" > /playground/last_pull.txt
