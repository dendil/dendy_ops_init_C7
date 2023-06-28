# useragent count
```bash
cat /opt/nginx/logs/access.log* |jq .agent |egrep -v "iPhone|Linux|Windows|Macintosh"|sort -n   |uniq -c  |sort
cat /opt/nginx/logs/access.log  |jq .xff  |sort  -n  |uniq -c
```
# block censys
```
server{ 
if ($http_user_agent ~* "^(?=.*censys)") {
    return 444;
}
}
```

# webdav
```bash
cd /opt/src 
git clone https://github.com/arut/nginx-dav-ext-module.git
./configure  --prefix=/opt/nginx-1.20.2 --with-http_ssl_module --user=nginx --group=nginx  --with-http_flv_module --with-http_stub_status_module --with-http_gzip_static_module --with-pcre --with-http_realip_module  --with-stream  --add-module=/opt/src/nginx-dav-ext-module --with-http_dav_module
```

# 
```bash
cd /opt/src
git clone https://github.com/vozlt/nginx-module-vts.git

./configure  --prefix=/opt/${NGINX_VERSION} --with-http_ssl_module --with-http_v2_module --user=nginx --group=nginx  --with-http_flv_module --with-http_stub_status_module --with-http_gzip_static_module --with-pcre --with-http_realip_module  --with-stream --add-module=/opt/src/nginx-module-vts 
```
# 新机器复制nginx 
```bash
REMOTE_IP="1.1.1.1"
scp -P52112 -r ${REMOTE_IP}:/opt/nginx .
cd /opt 
mv nginx nginx-1.20.1
ln -s nginx-1.20.1 nginx
useradd -r -d /dev/null -s /sbin/nologin nginx
scp -P52112 -r ${REMOTE_IP}:/etc/logrotate.d/nginx /etc/logrotate.d/nginx
chmod 644  /etc/logrotate.d/nginx
scp -P52112 -r ${REMOTE_IP}:/usr/lib/systemd/system/nginx.service /usr/lib/systemd/system/nginx.service
systemctl enable --now nginx
```