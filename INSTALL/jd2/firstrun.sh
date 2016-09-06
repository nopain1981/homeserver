#!/bin/bash

  mkdir -p /config/Downloads
  
  if [ ! -d /config/jd2 ]; then
    tar -zxvf /nobody/jd2.tar -C /config/
  fi
  chown -R swuser:swuser /config /tmp
  chmod -R g+rw /config
