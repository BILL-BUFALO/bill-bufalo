#!/bin/sh
scp root@10.1.0.50:/root/scrypts/zmail-status.txt /home/user/script-tmp/ > /dev/null
#VAR=$(cat /home/user/script-tmp/zmail-status.txt | grep ON | wc -l)
#echo "$VAR"
if cat /home/user/script-tmp/zmail-status.txt | grep -q ON ; then
   status_apache=""
else
   status_apache=""
fi
echo "$status_apache"
#    status_apache=""
#    status_apache=""
