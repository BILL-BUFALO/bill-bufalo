#!/bin/bash
ssh root@10.1.0.50 'su - zimbra -c "/opt/zimbra/bin/zmcontrol status | grep Running | wc -l"'

#ps ax | grep firefox | wc -l
