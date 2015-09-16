#!/bin/bash
clear

echo '[STOPING] EmulationStation...'
killall emulationstation

echo '[STOPING] FBCP...'
killall fbcp > /dev/null
con2fbmap 1 1

clear
exit 0
