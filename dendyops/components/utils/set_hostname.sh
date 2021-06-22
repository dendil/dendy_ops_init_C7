#!/usr/bin/env bash

set -e


New_hostname=$1
if [ -f  $hostfile  ];then
hostnamectl set-hostname --static $New_hostname
        echo " New hostname ==>  $New_hostname ...........ok!"
fi