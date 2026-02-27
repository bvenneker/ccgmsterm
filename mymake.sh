#!/bin/bash
cd /home/bart/Documenten/GitHub/ccgmsterm
make 
python3 prg2esp.py
/usr/bin/x64sc -silent -warp -autostartprgmode 1 -autostart build/ccgmsterm.prg &
