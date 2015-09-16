#!/bin/bash
clear

echo '[STARTING] FBCP...'
fbcp &
con2fbmap 1 0

echo '[STARTING] EmulationStation...'
emulationstation

echo '[STOPING] FBCP...'
killall fbcp > /dev/null
con2fbmap 1 1

clear
exit 0
