#!/usr/bin/env bash

# Skip failed install tools

yum install wget -y
yum install vim -y
# netstat
yum install net-tools -y
# host
yum install bind-utils -y
# telnet
yum install telnet -y
# unizp
yum install unzip -y
# htop instead of top
yum install htop -y
# mtr
yum install mtr -y
# tree
yum install tree -y  lrzsz dos2unix ntp gcc bc rsync chrony vim wget bash-completion lrzsz nmap nc tree htop iftop net-tools python3  yum-utils curl  bind-utils unzip mtr

#yum install -y vim psmisc tcpdump strace gdb libaio rsync gzip zip unzip \ 
#  autoconf make python-pip  python-devel  libffi-devel libxml2-devel libxslt-devel
#  libstdc++-static libevent-devel ncurses-devel  lrzsz gcc gcc-c++ make bzip2-devel 
#  zip-devel telnet wget locate ntpdate mysql mysql-devel mysql-devel openssl-devel 
#  libcurl-devel gd-devel libxml2-devel  libevent autojump 