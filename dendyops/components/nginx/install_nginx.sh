#!/usr/bin/env bash

#set -e

# Locate shell script path
SCRIPT_DIR=$(dirname $0)
if [ ${SCRIPT_DIR} != '.' ]
then
  cd ${SCRIPT_DIR}
fi

VERSION="$1"

if [ ! -n "${VERSION}" ]; then
    VERSION="1.25.0"
fi
[ -d /opt/src ]  || mkdir -p /opt/src
cd /opt/src
cp -r /opt/dendyops/components/nginx/nginx-module-vts /opt/src/
NGINX_VERSION="nginx-${VERSION}"
NGINX_PACKAGE="${NGINX_VERSION}.tar.gz"

# https://nginx.org/download/nginx-1.20.1.tar.gz
NGINX_MIRROR_URL="https://nginx.org"

yum install openssl openssl-devel  pcre pcre-devel  zlib-devel -y

egrep "^nginx" /etc/passwd >& /dev/null  
if [ $? -ne 0 ]  
then  
    useradd -r -d /dev/null -s /sbin/nologin nginx
fi  
 
[  -f ${NGINX_PACKAGE} ] ||  wget ${NGINX_MIRROR_URL}/download/${NGINX_PACKAGE} --no-check-certificate

tar -zxvf   ${NGINX_PACKAGE}
cd          ${NGINX_VERSION}
[ -d /opt/${NGINX_VERSION} ] &&  mv /opt/${NGINX_VERSION}{,.bak.$(date +%U%T)}
[ -L /opt/nginx ] && mv /opt/nginx{,.bak.$(date +%U%T)}
./configure  \
 --prefix=/opt/nginx \
 --conf-path=/opt/nginx_data/conf/ \
 --user=nginx \
 --group=nginx  \
 --with-pcre \
 --with-stream  \
 --with-http_ssl_module \
 --with-http_flv_module \
 --with-http_stub_status_module \
 --with-http_v2_module \
 --with-http_gzip_static_module \
 --with-http_realip_module  \
 --add-module=/opt/src/nginx-module-vts

make -j $(nproc)
make  install 
mv /opt/nginx /opt/${NGINX_VERSION}
ln -s /opt/${NGINX_VERSION} /opt/nginx
mkdir -p /opt/nginx_data/conf.d/  /opt/nginx_data/sslkey  /opt/nginx_data/sslkey/none /opt/nginx_data/temp
[ -f /opt/nginx_data/conf/nginx.conf               ] && mv /opt/nginx_data/conf/nginx.conf{,.bak.$(date +%U%T)}  && cp  /opt/dendyops/components/nginx/nginx.conf          /opt/nginx_data/conf/
[ -f /opt/nginx_data/conf.d/nginx_status.conf ] || cp  /opt/dendyops/components/nginx/nginx_status.conf   /opt/nginx_data/conf.d/
[ -f /etc/logrotate.d/nginx                   ] || cp  /opt/dendyops/components/nginx/logrotate_nginx     /etc/logrotate.d/nginx
[ -f /usr/lib/systemd/system/nginx.service    ] || cp  /opt/dendyops/components/nginx/nginx.service       /usr/lib/systemd/system/nginx.service
[ -f /opt/nginx_data/conf.d/default.conf      ] || cp  /opt/dendyops/components/nginx/default.conf        /opt/nginx_data/conf.d/default.conf



chown -R nginx:nginx /opt/${NGINX_VERSION}  /opt/nginx /opt/nginx_data

chmod 644 /opt/nginx_data/conf/nginx.conf
chmod 644  /etc/logrotate.d/nginx
chmod 644  /opt/nginx_data/conf/conf.d/nginx_status.conf
chmod 644  /opt/nginx_data/conf/conf.d/default.conf
cd /opt/nginx_data/sslkey/none
[ -f none.key ] && rm -f none.key 
[ -f none.pub ] && rm -f none.pub
[ -f none.csr ] && rm -f none.csr
[ -f none.crt ] && rm -f none.crt
openssl genrsa -out  none.key  2048 
openssl rsa    -in   none.key  -pubout   -out none.pub    
openssl req    -new  -key      none.key  -out none.csr  -subj     "/C=XX/L=Default City/O=Default Company Ltd"
openssl x509   -req  -days     3650      -in  none.csr  -signkey  none.key  -out  none.crt
systemctl enable nginx



echo "nginx install ${NGINX_VERSION} complete! "









