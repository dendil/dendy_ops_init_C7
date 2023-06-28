# enp5s0 ens.xxx  to eth0 
```bash
#确认网卡
ip a
dmesg | grep -i eth
sed -i  's/GRUB_CMDLINE_LINUX=""/GRUB_CMDLINE_LINUX="net.ifnames=0 biosdevname=0"/g' /etc/default/grub
update-grub2
# 配置网卡IP
reboot
```
# 配置网络
```bash
vim /etc/network/interfaces
# before
#allow-hotplug enp3s0
#iface enp3s0 inet dhcp
# after
# dhcp
allow-hotplug eth0
iface eth0 inet dhcp
# static 
allow-hotplug eth0
iface eth0  inet dhcp
################
```


# use huaweicloud source
```bash
cp -a /etc/apt/sources.list /etc/apt/sources.list.bak

cat > /etc/apt/sources.list << EOF
deb http://repo.huaweicloud.com/debian/ bullseye main contrib non-free
deb-src http://repo.huaweicloud.com/debian/ bullseye main contrib non-free
deb http://repo.huaweicloud.com/debian/ bullseye-updates main contrib non-free
deb-src http://repo.huaweicloud.com/debian/ bullseye-updates main contrib non-free
deb http://repo.huaweicloud.com/debian/ bullseye-backports main contrib non-free
deb-src http://repo.huaweicloud.com/debian/ bullseye-backports main contrib non-free
deb http://repo.huaweicloud.com/debian/ bullseye-proposed-updates main contrib non-free
deb-src http://repo.huaweicloud.com/debian/ bullseye-proposed-updates main contrib non-free
deb http://repo.huaweicloud.com/debian-security/ bullseye-security main contrib non-free
deb-src http://repo.huaweicloud.com/debian-security/ bullseye-security main contrib non-free
EOF

apt update 

```
# isntall tools
```bash

apt install -y git ntp ntpdate lrzsz lftp wget unzip zip bash-completion tree elinks nmap  tcptraceroute aptitude dos2unix net-tools htop iftop sshuttle vim 


```

# 同步时间
```bash
apt install ntpdate
ntpdate  0.cn.pool.ntp.org
timedatectl set-timezone Asia/Shanghai
```

# ssh 允许 root 登录
```bash

#sed -i '2aPermitRootLogin yes' /etc/ssh/sshd_config


cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak 
sed -i 's/#PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
sed -i 's/PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config
echo "UseDNS no" >>/etc/ssh/sshd_config
systemctl restart sshd
```

```bash
echo "ulimit -SHn 655350"               >> /etc/profile
echo "fs.file-max = 655350"             >> /etc/sysctl.conf
echo "root soft nofile 655350"          >> /etc/security/limits.conf
echo "root hard nofile 655350"          >> /etc/security/limits.conf
echo "* soft nofile 655350"             >> /etc/security/limits.conf
echo "* hard nofile 655350"             >> /etc/security/limits.conf
echo "session required pam_limits.so"   >> /etc/pam.d/common-session
```