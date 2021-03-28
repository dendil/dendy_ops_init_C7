#!/bin/bash
. ./system_init_functions.sh
WORK_DIR=$(cd $(dirname $0) && pwd)

cd $WORK_DIR
close_iptables
if [ ! -d  /usr/local/dendyops ];then
   cp -a dendyops /usr/local

fi
Msg 'install dendyops'