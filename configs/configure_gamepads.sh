#!/bin/bash

function configure_retroarch() {
    local cfg_index=6
    local path_cfg_bluetooth='/opt/retropie/configs/all/bluetooth'
    local path_cfg_usb='/opt/retropie/configs/all/usb'
    local cfg_current='/opt/retropie/configs/all/current/retroarch.cfg'
    local cfg_bluetooth="$path_cfg_bluetooth/retroarch.cfg"
    local cfg_usb="$path_cfg_usb/retroarch.cfg"
    local array=($(echo $@ |sed 's/ /\n/g'))
    local cfg_default=${array[$cfg_index]}
    local path_cfg_default=$(echo $cfg_default | sed "s|/retroarch.cfg||g")

    echo "DEFAULT CONFIG FILE: [$cfg_default]"

    if [[ ! $cfg_default =~ .*%RETRO_CONFIG%.* ]]; then
        # APPEND CONFIG FILE
        [ -f $cfg_default ] && cat $cfg_default > $cfg_current
        [ -s /tmp/btcheck ] && [ -f $path_cfg_default/bluetooth/retroarch.cfg ] && cfg_bluetooth=$path_cfg_default/bluetooth/retroarch.cfg
        [ ! -s /tmp/btcheck ] && [ -f $path_cfg_default/usb/retroarch.cfg ] && cfg_usb=$path_cfg_default/usb/retroarch.cfg
        [ -s /tmp/btcheck ] && echo "-- MODE BLUETOOTH ACTIVATED [$cfg_bluetooth] --" && cat $cfg_bluetooth >> $cfg_current
        [ ! -s /tmp/btcheck ] && echo "-- MODE USB ACTIVATED [$cfg_usb] --" && cat $cfg_usb >> $cfg_current

        [ -f $cfg_current ] && export command=$(echo $@ | sed "s|$cfg_default|$cfg_current|g")
    else
        # USE SPECIFIC CONFIG FILE
        [ -s /tmp/btcheck ] && echo "-- MODE BLUETOOTH ACTIVATED --" && cfg_current=$(echo $cfg_default | sed "s|%RETRO_CONFIG%|$path_cfg_bluetooth|g")
        [ ! -s /tmp/btcheck ] && echo "-- MODE USB ACTIVATED --" && cfg_current=$(echo $cfg_default | sed "s|%RETRO_CONFIG%|$path_cfg_usb|g")
    fi

    [ -f $cfg_current ] && echo "CONFIG FILE: [$cfg_current]" && export command=$(echo $@ | sed "s|$cfg_default|$cfg_current|g")
}

function configure_pifba() {
    [ -s /tmp/btcheck ] && echo "-- MODE BLUETOOTH ACTIVATED --" && sudo cp /opt/retropie/configs/all/bluetooth/fba2x-bluetooth.cfg /opt/retropie/emulators/pifba/fba2x.cfg
    [ ! -s /tmp/btcheck ] && echo "-- MODE USB ACTIVATED --" && sudo cp /opt/retropie/configs/all/usb/fba2x-usb.cfg /opt/retropie/emulators/pifba/fba2x.cfg
}

#CONFIGURE INPUT DEVICES
#echo "ORIGINAL COMMAND: [$@]"

[[ $(echo $@ | grep "/retroarch") ]] && configure_retroarch "$@"
[[ $(echo $@ | grep "/pifba") ]] && configure_pifba "$@" 

[[ $command == "" ]] && command=$@

