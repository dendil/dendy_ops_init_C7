#!/bin/bash
#mysql mysql-devel mysql-devel
#
. ./system_init_functions.sh
config_yum
yum clean all  >> /dev/null 2>&1
SOFT='dos2unix vim psmisc tcpdump strace gdb libaio rsync gzip zip unzip autoconf make python-pip  python-devel  libffi-devel libxml2-devel libxslt-devel  libstdc++-static libevent-devel ncurses-devel  lrzsz gcc gcc-c++ make bzip2-devel  telnet wget  ntpdate openssl-devel libcurl-devel gd-devel libxml2-devel  libevent autojump bash-completion nmap nc tree htop iftop net-tools chrony salt-minion '
yum install -y $SOFT >> /dev/null 2>&1
Msg "$SOFT installed"