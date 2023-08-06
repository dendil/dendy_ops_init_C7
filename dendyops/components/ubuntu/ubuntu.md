
# ubuntu 模板
```bash

apt install ntpdate
ntpdate  0.cn.pool.ntp.org
timedatectl set-timezone Asia/Shanghai
#timedatectl set-local-rtc 1
#timedatectl set-ntp yes


cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak 
sed -i 's/#PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
sed -i 's/PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config
echo "UseDNS no" >>/etc/ssh/sshd_config
echo -e 'dendy!@#$%^\ndendy!@#$%^'  |passwd root
systemctl restart sshd

vim /etc/netplan/00-installer-config.yaml
eth0


echo "ulimit -SHn 655350"               >> /etc/profile
echo "fs.file-max = 655350"             >> /etc/sysctl.conf
echo "root soft nofile 655350"          >> /etc/security/limits.conf
echo "root hard nofile 655350"          >> /etc/security/limits.conf
echo "* soft nofile 655350"             >> /etc/security/limits.conf
echo "* hard nofile 655350"             >> /etc/security/limits.conf
echo "session required pam_limits.so"   >> /etc/pam.d/common-session
source /etc/profile
echo 'export HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S  `whoami` "' >>/etc/profile

cat /etc/profile
export HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S  `whoami` "
export HISTFILESIZE=5000
export HISTSIZE=5000

source /etc/profile
cp /etc/apt/sources.list /etc/apt/sources.list.bak

cat /etc/apt/sources.list
deb-src http://archive.ubuntu.com/ubuntu xenial main restricted #Added by software-properties
deb http://mirrors.aliyun.com/ubuntu/ xenial main restricted
deb-src http://mirrors.aliyun.com/ubuntu/ xenial main restricted multiverse universe #Added by software-properties
deb-src http://mirrors.aliyun.com/ubuntu/ xenial-updates main restricted multiverse universe #Added by software-properties
deb http://mirrors.aliyun.com/ubuntu/ xenial universe
deb http://mirrors.aliyun.com/ubuntu/ xenial-updates universe
deb http://mirrors.aliyun.com/ubuntu/ xenial multiverse
deb http://mirrors.aliyun.com/ubuntu/ xenial-updates multiverse
deb http://mirrors.aliyun.com/ubuntu/ xenial-backports main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ xenial-backports main restricted universe multiverse #Added by software-properties
deb http://archive.canonical.com/ubuntu xenial partner
deb-src http://archive.canonical.com/ubuntu xenial partner
deb http://mirrors.aliyun.com/ubuntu/ xenial-security main restricted
deb-src http://mirrors.aliyun.com/ubuntu/ xenial-security main restricted multiverse universe #Added by software-properties
deb http://mirrors.aliyun.com/ubuntu/ xenial-security universe
deb http://mirrors.aliyun.com/ubuntu/ xenial-security multiverse

apt-get update

apt-get install -y git ntp ntpdate lrzsz lftp wget unzip zip bash-completion tree elinks nmap net-tools tcptraceroute aptitude dos2unix net-tools htop iftop sshuttle

# timedatectl set-timezone Asia/Shanghai
# apt-get -y install ntpdate
# sed -i '/# By default this script does nothing./a ntpdate -u ntp1.aliyun.com' /etc/rc.local

chmod a+x /etc/rc.local
apt-get autoclean 
apt-get clean
apt-get autoremove 


sed -i 's/GRUB_CMDLINE_LINUX=""/GRUB_CMDLINE_LINUX="net.ifnames=0 biosdevname=0 rhgb quiet"/g'  /etc/default/grub
update-grub




cat /etc/machine-id
echo "" > /etc/machine-id
cat >> /etc/profile << EOF
systemd-machine-id-setup

EOF
ls /etc/udev/rules.d/ 
ls /etc/udev/rules.d/  -a 
rm -fr /etc/udev/rules.d/*
systemctl stop systemd-journald.socket
find /var/log -type f -exec rm {} \;
mkdir -p /var/log/journal
chgrp systemd-journal /var/log/journal
chmod g+s /var/log/journal
cd /root && rm -fr .bash_history && history -c

```

ubuntu 升级内核
```
wget http://archive.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.0g-2ubuntu4_amd64.deb

wget https://kernel.ubuntu.com/~kernel-ppa/mainline/v4.20.17/linux-headers-4.20.17-042017_4.20.17-042017.201903190933_all.deb

wget https://kernel.ubuntu.com/~kernel-ppa/mainline/v4.20.17/linux-headers-4.20.17-042017-generic_4.20.17-042017.201903190933_amd64.deb

wget https://kernel.ubuntu.com/~kernel-ppa/mainline/v4.20.17/linux-image-unsigned-4.20.17-042017-generic_4.20.17-042017.201903190933_amd64.deb

wget https://kernel.ubuntu.com/~kernel-ppa/mainline/v4.20.17/linux-modules-4.20.17-042017-generic_4.20.17-042017.201903190933_amd64.deb



dpkg -i *.deb
apt-get -f install -y
reboot
uname -sr
```