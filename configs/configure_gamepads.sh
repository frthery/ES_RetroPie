#!/bin/bash

function configure_retroarch() {
    local cfg_index=6
    #local cfg_index=2
    local cfg_current='/opt/retropie/configs/all/current/retroarch.cfg'
    local array=($(echo $@ |sed 's/ /\n/g'))
    local cfg_default=${array[$cfg_index]}

    echo "DEFAULT CONFIG FILE: [$cfg_default]"

    if [[ ! $cfg_default =~ .*%RETRO_CONFIG%.* ]]; then
        # APPEND CONFIG FILE
        [ -f $cfg_default ] && cat $cfg_default > $cfg_current
        [ -s /tmp/btcheck ] && echo "-- MODE BLUETOOTH ACTIVATED --" && cat /opt/retropie/configs/all/bluetooth/retroarch.cfg >> $cfg_current
        [ ! -s /tmp/btcheck ] && echo "-- MODE USB ACTIVATED --" && cat /opt/retropie/configs/all/usb/retroarch.cfg >> $cfg_current
    else
        # USE SPECIFIC CONFIG FILE
        [ -s /tmp/btcheck ] && echo "-- MODE BLUETOOTH ACTIVATED --" && cfg_current='/opt/retropie/configs/all/bluetooth/retroarch.cfg' #export cmd=$(echo $@ | sed "s/%RETRO_CONFIG%/\/opt\/retropie\/configs\/all\/bluetooth\//g")
        [ ! -s /tmp/btcheck ] && echo "-- MODE USB ACTIVATED --" && cfg_current='/opt/retropie/configs/all/usb/retroarch.cfg' #export cmd=$(echo $@ | sed "s/%RETRO_CONFIG%/\/opt\/retropie\/configs\/all\/usb\//g")
    fi

    [ -f $cfg_current ] && echo "CONFIG FILE: [$cfg_current]" && export cmd=$(echo $@ | sed "s|$cfg_default|$cfg_current|g")
}

function configure_pifba() {
    [ -s /tmp/btcheck ] && echo "-- MODE BLUETOOTH ACTIVATED --" && sudo cp /opt/retropie/configs/all/bluetooth/fba2x-bluetooth.cfg /opt/retropie/emulators/pifba/fba2x.cfg
    [ ! -s /tmp/btcheck ] && echo "-- MODE USB ACTIVATED --" && sudo cp /opt/retropie/configs/all/usb/fba2x-usb.cfg /opt/retropie/emulators/pifba/fba2x.cfg
}

#CONFIGURE INPUT DEVICES
#[ ! -s /tmp/btcheck ] && [[ $(echo $cmd | grep "/retroarch") ]] && echo "-- MODE USB ACTIVATED --" && configure_retroarch $cmd #export cmd=$(echo $cmd | sed "s/%RETRO_CONFIG%/\/opt\/retropie\/configs\/all\/usb\//g")
[[ $(echo $@ | grep "/retroarch") ]] && configure_retroarch "$@"
[[ $(echo $@ | grep "/pifba") ]] && configure_pifba "$@" 

[[ $cmd == "" ]] && cmd=$@

