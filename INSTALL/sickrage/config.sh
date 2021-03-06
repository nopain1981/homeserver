#!/bin/bash

#Set default values for userid, username, groupid and groupname if not set yet
PUID=${PUID:=50000}
PUSER=${PUSER:=swuser}
PGID=${PGID:=50000}
PGROUP=${PGROUP:=swuser}

#Create internal sickrage group and user 
#(which will be mapped to external group and user, and used to run the process)
GN=`getent group $PUID | awk -F':' '{print \$1}'`
if [ $GN ]; then
  echo "[WARNING] A group with id $PGID exists already [in use by $GN] and won't be created."
else
  echo "[INFO] Create group $PGROUP with id $PGID"
  #create group similar to:
  #  addgroup --gid $PGID $PGROUP
  addgroup -g $PGID $PGROUP
fi

UN=`grep "^.*:$PUID" /etc/passwd | awk -F':' '{print \$1}'`
if [ $UN ]; then
  echo "[WARNING] A user with id $PUID exists already [in use by $UN] and won't be created."
else
  echo "[INFO] Create user $PUSER with id $PUID"
  #create user similar to:
  #  adduser --shell /bin/bash --no-create-home --uid $PUID --ingroup $PGROUP --disabled-password --gecos "" $PUSER
  adduser -s /bin/bash -H -u $PUID -G $PGROUP -D -g "" $PUSER
fi

#set the timezone
source $SR_HOME/set_timezone.sh

