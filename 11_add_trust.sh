#!/bin/bash

if [ ! -f /root/.ssh/authorized_keys ];then
    mkdir /root/.ssh
    chmod 700 /root/.ssh
    touch /root/.ssh/authorized_keys
    chmod 600 /root/.ssh/authorized_keys
fi

if ( ! grep -q "dendy@Dendy" /root/.ssh/authorized_keys );then
    echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCeZG3XJpb3hpFg/KXXqbjwl4CAIks+k0sdhE67h7e7gtmpeZxHnKIVCPaQb2KfEKoCka9DNKH4VMYJ7Ce6zJaj+cHu7nRnrumrhmgXMm0bv7UjitzosrUBpdtkwBH/y+Dz9fhqOaNIRM/vaNG4azSTNddjyHqzaWZ7vhZIuATkaGIPI3GO59opRZV5IEUdZoHL9Ea9duYMoQwvMZfTKR59qD2/kLmgwO7Q73TqyONIRN9R3VA9ObSX03H2HXwgMzbLxgvtoSiwFzbTY05OsUojRHyV86Cmj1/Twn0hH1oZgBkLAn+3gPcmepzXTTJmQeavT+Nze8Mk6pahQJC8D369RQc61tXJ3Y5HzQAhm/Q5Ykv4qrehu7t6VwUESlXwYkHbxyoAQvQRDBlVVUjFK/I9jNag7fJOr94kY4Z5zMiQFZ/Txurlsew8tC9qIQSXXH+0GChuBgdTZyfVqIMuPu9yL9qsJNJMjlef8vROzn0eQAvcG996b2NbY3QNyyPB/Js= dendy@Dendy' >> /root/.ssh/authorized_keys
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
