#!/bin/bash
# 对安装在VMware上的CentOS7.X进行封装，是为了后续的实验环境需要，
# 可以批量去生成Linux系统。通过虚拟机模版来创建一台CentOS系统，
# 跟原来机器一样，去掉了唯一性，而通过克隆出来的虚拟机，
# 会与被克隆的机器一样，包含网卡的信息等。
#***********************************************************
cat /etc/machine-id
echo "" > /etc/machine-id
cat >> /etc/profile << EOF
systemd-machine-id-setup
EOF
ls /etc/udev/rules.d/ 
ls /etc/udev/rules.d/  -a 
rm -fr /etc/udev/rules.d/*
rm -fr /etc/ssh/ssh_host_*
rm -fr /etc/sysconfig/network-scripts/ifcfg-e*
systemctl stop systemd-journald.socket
find /var/log -type f -exec rm {} \;
mkdir -p /var/log/journal
chgrp systemd-journal /var/log/journal
chmod g+s /var/log/journal
cd /root && rm -fr .bash_history && history -c
