#!/bin/bash


if [ -d "/home/bart/Documenten/GitHub" ]; then
    cd /home/bart/Documenten/GitHub/ccgmsterm
else
    cd /home/bart/GitHub/ccgmsterm
fi


make 
python3 prg2esp.py

if [ -f "/usr/bin/x64sc" ]; then
    /usr/bin/x64sc -silent -warp -autostartprgmode 1 -autostart build/ccgmsterm.prg &
else
    /usr/local/bin/x64sc -silent -warp -autostartprgmode 1 -autostart build/ccgmsterm.prg &
fi

sh warp_off.sh
