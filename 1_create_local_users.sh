#!/bin/sh

#cp /etc/login.defs /etc/login.defs.bak.`date +%Y%m%d%H%M%S`

#umask 002
. ./system_init_functions.sh
for usernum in `seq 0 5`
do
    username="user0"$usernum
    if [ `cat /etc/passwd |grep $username |wc -l` -eq 0  ];then
        useradd -m -d /home/$username -g users -u 200$usernum $username
        for file in /etc/skel/.bash*
        do
            if [ ! -f /home/$username/`basename $file` ];then
                cp $file /home/$username/
            fi
        done
        chmod 755 /home/$username
        echo "umask 002" >> /home/$username/.bash_profile
        chown -R $username.users /home/$username
    fi
done
#create user mysql for DBA
if [ `cat /etc/passwd |grep mysql |wc -l` -eq 0  ];then

groupadd mysql -g 202
useradd -M -g 202 -G users -u 20001 mysql
fi
##create code
if [ `cat /etc/passwd |grep code |wc -l` -eq 0  ];then

groupadd code -g 555
useradd -M -g 555 -G users -u 5555 code
fi

add_sudoer
