#!/bin/bash

here=$(dirname ${BASH_SOURCE[0]})
mysuspend="$here/mysuspend.sh"
if [ -x $mysuspend ]; then
    $mysuspend &
fi
i3lock --ignore-empty-password --color=000000 --show-failed-attempts
