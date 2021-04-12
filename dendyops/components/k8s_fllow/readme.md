# 配置cobbler
```bash


10.4.7.11	00:0c:29:1f:88:c7 amd7-11.host.com
10.4.7.12	00:0c:29:f2:b7:32 amd7-12.host.com
10.4.7.21	00:0c:29:86:d0:f1 amd7-21.host.com
10.4.7.22	00:0c:29:91:dd:d1 amd7-22.host.com
10.4.7.200	00:0c:29:2f:d6:e4 amd7-200.host.com



```

# use amd5
```
#add dendyops
cd /tmp && git clone https://github.com/dendil/dendy_ops_init_C7.git &&cd dendy_ops_init_C7 &&find . -name '*.sh' -exec chmod u+x {} \; &&bash init.sh update
# dhcp  to static
/opt/dendyops/components/utils/config_static_eth0.sh 
/opt/dendyops/components/utils/make_hosts.sh /opt/dendyops/components/k8s_fllow/hosts.txt
mv /etc/hosts{,.bak.$RANDOM} 
cp /opt/hosts /etc/
# 设置主机名
/opt/dendyops/components/utils/set_hostname.sh
# 生成密钥
/opt/dendyops/components/ssh/ssh_key_gen.sh
# 分发密钥
/opt/dendyops/components/ssh/fenfa_clinet_ssk.sh ~/.ssh/id_rsa.pub 123456 /opt/dendyops/components/k8s_fllow/hosts.txt

/opt/dendyops/components/ssh/fenfa_clinet_ssk_test.sh /opt/dendyops/components/k8s_fllow/hosts.txt hostname
```