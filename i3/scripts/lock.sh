#!/bin/bash

LOCKER=$(systemctl --user show-environment | grep -oP 'LOCKER=\K.*')

if [ -z "$LOCKER" ]; then
    LOCKER=1
fi

if [ "$LOCKER" -eq 0 ]; then
    exit 0
fi

setxkbmap us

sleep 0.2

# lock
i3lock --nofork
