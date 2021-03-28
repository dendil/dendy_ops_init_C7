#!/bin/bash
. ./system_init_functions.sh
WORK_DIR=$(cd $(dirname $0) && pwd)

cd $WORK_DIR

cp profile.d/* /etc/profile.d/

Msg 'set profile ok'

