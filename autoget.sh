#/bin/bash
cd /playground/homeserver \
&& git pull
echo "Last Refresh occoured: `date`" > /playground/last_pull.txt
