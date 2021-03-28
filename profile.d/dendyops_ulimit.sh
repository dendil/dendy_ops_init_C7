#!/bin/bash

uid=`id -u`

if [ $uid -eq 0 ];then
    ulimit -HSn 102400
fi
