#!/bin/bash

if [ "X${DCKR_UID}" == "X" ];then
    DCKR_UID="1000"
fi
if [ "X${DCKR_GID}" == "X" ];then
    DCKR_GID="50"
fi
groupadd -g "${DCKR_GID}" eagergroup
useradd -d /home/eager/ -M -g "${DCKR_GID}" -u "${DCKR_UID}" eager
echo "eager:eager" | chpasswd
sleep 1
chown -R eager: /home/eager
ln -s /data /home/eager/
