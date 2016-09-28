#!/bin/bash

exec /sbin/setuser swuser python /opt/headphones/Headphones.py --datadir=/config --nolaunch
