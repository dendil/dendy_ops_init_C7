# 安装cobbler 
centos 7
```bash
#     先安装cobbler相关软件包　　--这一次直接使用我们准备好的公网yum源安装就可以了
 yum install -y cobbler cobbler-web　tftp* rsync xinetd http* syslinux dhcp* pykickstart　fence-agents xinetd   debmirror  



#启动服务，并使用cobbler check查询哪些需要修改

systemctl start cobblerd.service;systemctl enable cobblerd.service;systemctl restart httpd.service ;systemctl enable httpd.service;cobbler check





按照cobbler check对应的信息修改
下边有快速命令
#384 server: 192.168.10.223 --换成cobbler服务器端的IP
#272 next_server: 192.168.10.223 --同上
#101 default_password_crypted: "$1$werwqerw$.prcfrYFbwuvkD8XspayN."  --把密码字符串换成你上面产生的字符串(此密码为客户机安装后的root登录密码)
#242 manage_dhcp: 0   -- 1 开启dhcp 0 关闭
#-------------------------------------------------------------
#--  生成新的加密密码  加盐解析
#--  openssl passwd -1 -salt 'xcvsfdsdfwq' '123456'
#--   $1$xcvsfdsd$cGxdcHuQGCnu5vJw5M7zX1
#--
#-- --在101行把上面产生的密码字符串粘贴到""里替代原来的字符串
#-- vim /etc/cobbler/settings	
#-- default_password_crypted: "$1$xcvsfdsd$cGxdcHuQGCnu5vJw5M7zX1"
#-------------------------------------------------------------

快速命令  修改为自己对应的ip

cp /etc/cobbler/settings{,.bak}
sed -i 's/server:\ 127.0.0.1/server:\ 192.168.189.5/'  /etc/cobbler/settings
sed -i 's/next_server:\ 127.0.0.1/next_server:\ 192.168.189.5/'  /etc/cobbler/settings
sed -i 242s/0/1/ /etc/cobbler/settings
sed -i 's/\$1\$mF86\/UHC\$WvcIcX2t6crBz2onWxyac./\$1\$xcvsfdsd\$cGxdcHuQGCnu5vJw5M7zX1/' /etc/cobbler/settings
sed -i /disable/s/yes/no/ /etc/xinetd.d/tftp

使用coobler 需要关闭 路由器dhcp
# 启动服务
systemctl start rsyncd.service;systemctl enable rsyncd.service;systemctl restart cobblerd.service
# 获取加载器
cobbler get-loaders



#确定iso镜像是否挂载
vmware 虚拟机可以
mkdir /yum
mount /dev/sr0 /yum/
cobbler import --path=/yum/ --name=centos7.9


#   --导入成功后，确认导入的镜像名
cobbler distro list
#   centos7.9-x86_64
#    --导入成功后，确认默认的profile名
cobbler profile list
#  centos7.9-x86_64




修改dhcp配置模块
# --在此文件的第21行到第25行修改成你对应的网段和ip
vim /etc/cobbler/dhcp.template　	

subnet 192.168.1.0 netmask 255.255.255.0 {
     option routers             192.168.1.2;
     option domain-name-servers 192.168.1.2;
     option subnet-mask         255.255.255.0;
     range dynamic-bootp        192.168.1.100 192.168.1.254;

使用cobbler sync同步，并启动xinetd服务
cobbler sync
systemctl restart xinetd.service;systemctl enable xinetd;systemctl enable dhcpd



# 新建 dendyops 
cd /tmp
cd /tmp && git clone https://github.com/dendil/dendy_ops_init_C7.git && cd dendy_ops_init_C7 && chmod +X -R 
nohup python3 -m http.server -b 0.0.0.0 8888 &  
# ks 文件依赖
```
```bash
vim /root/centos7_ks.ks
#platform=x86, AMD64, or Intel EM64T
#version=DEVEL
# Install OS instead of upgrade
install
# Keyboard layouts
keyboard 'us'
# Root password
rootpw --iscrypted $1$GgZfpM8B$tmahm23uEOIHKbt4R2o7A0
# System language
lang en_US.UTF-8 --addsupport=zh_CN.UTF-8
# System authorization information
auth  --useshadow  --passalgo=sha512
# Use text mode install
text
# SELinux configuration
selinux --disabled
# Do not configure the X Window System
skipx


# Firewall configuration
firewall --disabled
# Network information
network  --bootproto=dhcp --device=eth0
# Reboot after installation
reboot
# System timezone
timezone Asia/Shanghai
# Use network installation
url --url="http://192.168.198.5/cobbler/ks_mirror/centos7.9.2/"
#url --url="https://mirrors.tuna.tsinghua.edu.cn/centos/7/os/x86_64/"
# System bootloader configuration
bootloader --append="net.ifnames=0 biosdevname=0" --location=mbr
# Partition clearing information
clearpart --all --initlabel
# Disk partitioning information
part /boot --asprimary --ondisk=sda --fstype="xfs" --size=300
part / --asprimary --ondisk=sda --fstype="xfs" --grow  --size=1

%packages
@base
@development
dos2unix
-dlm
-kmod-kvdo
-lvm2

%end
%addon com_redhat_kdump --disable --reserve-mb='auto'
%post
wget http://192.168.189.5:8888/dendyops/components/utils/config_static_eth0.sh
bash config_static_eth0.sh
%addon com_redhat_kdump --disable --reserve-mb='auto'
%end

```
```





mv  /root/centos7_ks.ks  /var/lib/cobbler/kickstarts/centos7_ks.ks
# cobbler profile add --name=my_profile1 --distro=centos7.9.2-x86_64 --kickstart=/var/lib/cobbler/kickstarts/centos7_ks.ks

# cobbler profile list
   centos7.3-x86_64
   my_profile1

cobbler sync
systemctl restart xinetd.service;systemctl restart rsyncd.service
最后进行安装测试





















```
















使用system-config-kickstart图形自定义ks文件

# vim /etc/yum.repos.d/local.repo    --这里有个小问题，需要把软件仓库里改成development，图形才能选择包，否则图形在选择软件包那一步看不到
[development]
name=development
baseurl=file:///yum/
enabled=1
gpgcheck=0


# yum clean all

# system-config-kickstart  --图形自定义ks文件，过程省略