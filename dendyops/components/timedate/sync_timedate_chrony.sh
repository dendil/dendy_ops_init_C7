#!/usr/bin/env bash

set -e

./install_ntp.sh

# Current time
timedatectl

# Set time zone
timedatectl set-timezone Asia/Shanghai

# Enable ntp time sync
timedatectl set-ntp yes

# Use local RTC time
timedatectl set-local-rtc 1

# Enable and start chronyd service
yum install chrony -y

echo 'server 0.cn.pool.ntp.org iburst' >> /etc/chrony.conf
echo 'server 1.cn.pool.ntp.org iburst' >> /etc/chrony.conf
echo 'server 2.cn.pool.ntp.org iburst' >> /etc/chrony.conf
echo 'server 3.cn.pool.ntp.org iburst' >> /etc/chrony.conf

systemctl enable chronyd
systemctl start chronyd


# Verify ntp sync status
netstat -nupl | grep 323
chronyc sources
chronyc tracking

# Current time
date -R

timedatectl