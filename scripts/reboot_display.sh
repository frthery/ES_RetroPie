#!/bin/bash

OPT_HDMI=0
OPT_DEFAULT=0

while [ "$1" != "" ]; do
    PARAM=`echo $1 | awk -F= '{print $1}'`
    VALUE=`echo $1 | awk -F= '{print $2}'`
    case $PARAM in
        -h | --help)
            #usage
            exit
            ;;
        -hdmi)
            OPT_HDMI=1
            ;;
        -default)
            OPT_DEFAULT=1
            ;;
        *)
            echo "[ERROR] unknown parameter \"$PARAM\""
            #usage
            exit 1
            ;;
    esac
    shift
done

echo '[UPDATE] DISPLAY...'
[ $OPT_HDMI -eq 1 ] && sudo cp /boot/config_hdmi.txt /boot/config.txt && echo '[UPDATE] DISPLAY HDMI Done!'
[ $OPT_DEFAULT -eq 1 ] && sudo cp /boot/config_default.txt /boot/config.txt && echo '[UPDATE] DISPLAY PITFT DEFAULT Done!'

echo '[REBOOT] RPI REBOOT...'
sudo reboot

exit 0
