#!/bin/bash

if [ ! -f /root/.ssh/authorized_keys ];then
    mkdir /root/.ssh
    chmod 700 /root/.ssh
    touch /root/.ssh/authorized_keys
    chmod 600 /root/.ssh/authorized_keys
fi

if ( ! grep -q "root@monitor" /root/.ssh/authorized_keys );then
    echo 'ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA6wvQhFUKBK+YvAmJg3TtUuQ2iw/DO+0cpIPVVold1Nvs+I8b40FIDj+64gUla+TAGXZcCA2KSFZUC1u9j5T3K328cfXC+bFMX6Zxx52KJP7tR9K7gpdNL5PVVpMC+x4zgtbKhIeMnBWQGczzjf1Jux2hrpCnaPBcjVnCH2fm1k65gB7Ctv1269/HSfoeRZ9dSUZwT9Kutm3X4cIjCTYa4xQcLgdgSldniUcyTEpsvyYukXZayCzwL0n0hdpH+z6F4t8FmbCOJQBZwcm93XA2QDsCGeZwDmPtalOdWvOq3ko/Lm0ttglmyzokACz1R6BiHTgRHbQ7bv1x/J7IdB087Q== root@monitor' >> /root/.ssh/authorized_keys
fi


if [ ! -f /home/user00/.ssh/authorized_keys ];then
    mkdir /home/user00/.ssh
    chmod 700 /home/user00/.ssh
    touch  /home/user00/.ssh/authorized_keys
    chown user00:users /home/user00/.ssh/authorized_keys
    chmod 600  home/user00/.ssh/authorized_keys
fi

if ( ! grep -q "user00@monitor" /home/user00/.ssh/authorized_keys );then
    echo 'ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA1rr5dN9rOwYab42WPqB7dJLx6Na4K7SnDZhiNfDPzYVNNzlu4JxZu3Y5yySP5+tIi0NEWNxj1PwjAUOnTgHiHMZ9bP5uC4kFu7/M+BH+Qj6IW/ew2UMs6BY0L1o5Z9ut+UAdhz63vqv/Cr8gKfXjFcK8//9PG1XHnoOdsZ+WTNMHYIIxGcj7asMNQbCVie0kEXz61yGYMVTVKR83vXV0CW4lu65Gp9r2hKSecAaeiDv5KV1QidnA2HD5Tbtg3Q2p5FpSOJT7e9SL0LA/242y9Lu4HXJ4ucbxo5e64jq5+3HrnOho5yw2boWFdA0phuty16NUeiiLmsFUMeY+/a0Z4Q== user00@monitor'  >> /data/home/user00/.ssh/authorized_keys
fi

echo `cat user00_passwd` | passwd --stdin user00
#rm user00_passwd root_passwd
