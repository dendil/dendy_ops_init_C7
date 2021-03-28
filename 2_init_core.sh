#!/bin/bash
. ./system_init_functions.sh
INIT_CONFIG_FILE="/etc/rc.d/rc.local"

if [ ! -d /home/corefile ]
then
        mkdir /home/corefile
fi

chmod 777 /home/corefile

if [ -f /proc/sys/kernel/core_uses_pid ]
then
        echo 1 > /proc/sys/kernel/core_uses_pid
else
        echo "/proc/sys/kernel/core_uses_pid  not exist!"
fi

if [ -f /proc/sys/kernel/core_pattern ]
then
        echo '/home/corefile/core_%e_%t' >/proc/sys/kernel/core_pattern
fi

if [ -f ${INIT_CONFIG_FILE} ]
then
    if ( ! grep -q "#added by dendy_ops for set core path" ${INIT_CONFIG_FILE} );then
    	echo  '' >>${INIT_CONFIG_FILE}
    	echo  '#added by dendy_ops for set core path' >>${INIT_CONFIG_FILE}
    	echo  'echo 1 > /proc/sys/kernel/core_uses_pid' >>${INIT_CONFIG_FILE}
    	echo  'echo /home/corefile/core_%e_%t >/proc/sys/kernel/core_pattern ' >> ${INIT_CONFIG_FILE}
    	echo  '' >>${INIT_CONFIG_FILE}
    fi
fi
Msg "'#added by dendy_ops for set core path' ${INIT_CONFIG_FILE}"