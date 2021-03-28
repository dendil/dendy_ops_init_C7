#!/bin/bash

cp ssh/ssh*config /etc/ssh/

systemctl restart sshd
