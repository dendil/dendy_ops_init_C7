#!/bin/bash
if [ `cat /etc/security/limits.conf|grep 'See 33069'|wc -l` -eq 0 ];then
    mv /etc/sysctl.conf{,.bak}
    cp ./sysctl.conf /etc/
    sysctl -p >>/dev/null 2>&1
fi