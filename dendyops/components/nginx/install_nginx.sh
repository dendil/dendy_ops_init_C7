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
    VERSION="1.20.1"
fi
mkdir -p /opt/src
cd /opt/src/
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
 
wget ${NGINX_MIRROR_URL}/download/${NGINX_PACKAGE} --no-check-certificate

tar -zxvf ${NGINX_PACKAGE}
cd   ${NGINX_VERSION}
./configure  --prefix=/opt/${NGINX_VERSION} --with-http_ssl_module --user=nginx --group=nginx  --with-http_flv_module --with-http_stub_status_module --with-http_gzip_static_module --with-pcre --with-http_realip_module  --with-stream 
make -j $(nproc)
make  install -j $(nproc)
ln -s /opt/${NGINX_VERSION} /opt/nginx
cp  /opt/dendyops/components/nginx/nginx.conf   /opt/nginx/conf/
mkdir -p /opt/nginx/conf/conf.d/
chown -R nginx:nginx /opt/${NGINX_VERSION}  /opt/nginx


# install nginx




echo "nginx install ${NGINX_VERSION} complete! "









