#!/bin/bash

CURRENT=$(systemctl --user show-environment | grep -oP 'LOCKER=\K.*')

if [ "$CURRENT" = "1" ]; then
    systemctl --user set-environment LOCKER=0
    echo "Locker set to 0" | systemd-cat -t toggle_lock -p info
    exit 0
else 
    systemctl --user set-environment LOCKER=1
    echo "Locker set to 1" | systemd-cat -t toggle_lock -p info
    exit 0
fi

