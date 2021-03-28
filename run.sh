#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin:PATH
export PATH
. /etc/init.d/functions
. ./init/system_init_functions.sh
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
./init/0_install_dendyops.sh
./init/1_create_local_users.sh
./init/2_init_core.sh
./init/3_set_profile.sh
./init/4_user_evn_set.sh
#./init/init/5_sethostname.sh $Hostname
#SetHostname $Hostname
./init/6_sysctl.conf.sh
./init/7_yum_install.sh
#./init/8_init_iptables.sh
#./init/9_set_crontab.sh
sync_time
time_cron

#./init/11_add_trust.sh
./init/10_ssh_set.sh
