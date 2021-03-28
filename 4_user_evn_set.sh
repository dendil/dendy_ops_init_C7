#!/bin/bash
####################################################
#user00 user init script
#Created by tommyiu, modified by curuwang
####################################################
. ./system_init_functions.sh
workdir=`dirname $0`
cd $workdir

#localip=$(ip a  |egrep 'eth0|ens32' |grep inet |awk '{print $2}')
localip=$IP
if [ ! -f /root/.vimrc ];then
    cp vimrc /root/.vimrc
fi
if [ ! -f /home/user00/.vimrc ];then
    cp vimrc  /home/user00/.vimrc
    chown user00:users /home/user00/.vimrc
fi

if [ `cat /etc/security/limits.d/20-nproc.conf |grep 'See 33069'|wc -l` -eq 0 ];then
    cp 20-nproc.conf /etc/security/limits.d/
    chown root:root /etc/security/limits.d/20-nproc.conf
fi
user00_limits_set(){
Msg "setup system limits for user00"
if grep -qE '^[^#]+user00.*nofile' /etc/security/limits.conf; then
    Msg "nofile already in limits.conf"
else
    Msg "add nofile to limits.conf"
    cat << EOF >> /etc/security/limits.conf
user00        hard    nofile  102400
user00        soft    nofile  102400
EOF
fi

if grep -qE '^[^#]+user00.*memlock' /etc/security/limits.conf; then
    Msg "memlock already in limits.conf"
else
    Msg "add memlock to limits.conf"
    cat << EOF >> /etc/security/limits.conf
user00        hard    memlock  4194304
user00        soft    memlock  4194304
EOF
fi


}





user00_limits_set

