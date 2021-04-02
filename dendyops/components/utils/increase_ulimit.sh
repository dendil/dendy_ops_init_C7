#!/usr/bin/env bash

set -e

# https://access.redhat.com/solutions/61334
# https://blog.csdn.net/duanbiren123/article/details/80190750
function old(){
ulimit -u unlimited
ulimit -n 65535

cp -p /etc/security/limits.conf /etc/security/limits.conf.bak$(date '+%Y%m%d%H%M%S')

cat <<EOF >> /etc/security/limits.conf
root soft nofile 65535
root hard nofile 65535
* soft nofile 65535
* hard nofile 65535
EOF
}

function Openfile(){
    if [ `cat /etc/security/limits.conf|grep 102400|grep -v grep |wc -l ` -lt 1 ];then
        /bin/cp /etc/security/limits.conf  /etc/security/limits.conf.$(date +%U%T)
        sed -i '/#\ End\ of\ file/ i\*\t\t-\tnofile\t\t102400' /etc/security/limits.conf
    fi
    ulimit -HSn 102400
    echo "ulimited. -HSn. 102400......ok"
}
Openfile