#!/bin/bash

#echo '[KILLALL] EMULATIONSTATION...'
#sudo killall emulationstation

pushd ~/

# EXEC OC BESTSETS SYNCHRONIZATION
echo '[SYNC] oc_bestsets_downloader.sh...'
~/oc_bestsets_downloader.sh

popd

#echo '[RESTART] EMULATIONSTATION...'
#emulationstation &

#echo '[REBOOT] RPI REBOOT...'
#sudo reboot

exit 0

