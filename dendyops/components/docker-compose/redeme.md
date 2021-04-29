安装完Harbor不要修改配置文件里的密码，有可能会导致你登录不了

harbor现在是使用postgresql 数据库了。不再支持mysql，网上有很多重置Mysql密码的，可以略过了。

我刚开始修改了默认的密码，然后就登录不了了（一直提示用户名或密码不正确），卸载重新重新安装也不可以，可能harbor的数据没有删干净，修改配置文件（harbor.cfg）一直登不上去。

我把密码默认的Harbor12345 修改为： 12345 然后死活登陆不上。
下面为重置Harbor 仓库密码的方式
具体步骤：

# 进入`[harbor-db]`容器内部

`docker exec -it harbor-db /bin/bash`

# 进入postgresql命令行

`psql -h postgresql -d postgres -U postgres` 

#这要输入默认密码：root123 。


 #或者用这个可以不输入密码。

`psql -U postgres -d postgres -h 127.0.0.1 -p 5432`

# 切换到harbor所在的数据库

`\c registry`

# 查看harbor_user表

`select * from harbor_user;`

# 例如修改admin的密码，修改为初始化密码 Harbor12345 ，修改好了之后再可以从web ui上再改一次。
```bash
#Harbor12345
update harbor_user set password='a71a7d0df981a61cbb53a97ed8d78f3e',salt='ah3fdh5b7yxepalg9z45bu8zb36sszmr' where username='admin';

#harbor.od.com
update harbor_user set password='3c56cac078b9449a38eeaa6c14d4f6d4',salt='0qfzyye4larib2mmdzossznblecp2zhk' where username='admin';

```
# 退出 \q 退出postgresql，exit退出容器。
```
\q
exit
```