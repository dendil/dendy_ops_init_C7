#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin:PATH
export PATH
. /etc/init.d/functions
. ./system_init_functions.sh
######################################################################
#锁文件
LOCK_FILE="auto_install.lock"
LOCK_DIR="/var/lock/auto_install"
#日志文件
LOG_DIR="/var/log"
LOG_FILE="auto_install.log"
Local_URL=''
# 同步时间
innerip=$IP
Hostname=$1

chmod +x ./*.sh
./0_install_dendyops.sh
./1_create_local_users.sh
./2_init_core.sh
./3_set_profile.sh
./4_user_evn_set.sh
#./5_sethostname.sh $Hostname
#SetHostname $Hostname
./6_sysctl.conf.sh
./7_yum_install.sh
#./8_init_iptables.sh
#./9_set_crontab.sh
sync_time
time_cron

./11_add_trust.sh
./10_ssh_set.sh
