
# 下边的参数 要按实际修改
sed -i 's/rhgb quiet"/GRUB_CMDLINE_LINUX="net.ifnames=0 biosdevname=0 rhgb quiet"/g'  /etc/default/grub
grub2-mkconfig -o /boot/grub2/grub.cfg
mv /etc/sysconfig/network-scripts/ifcfg-ens33 /etc/sysconfig/network-scripts/ifcfg-eth0
sed -i '/UUID/d' /etc/sysconfig/network-scripts/ifcfg-eth0
sed -i 's/ens32/eth0/g' /etc/sysconfig/network-scripts/ifcfg-eth0