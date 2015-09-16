#!/bin/bash

#FORCE DEFAULT MODE
mode=''

path_cfg_bluetooth='/opt/retropie/configs/all/bluetooth'
path_cfg_usb='/opt/retropie/configs/all/usb'
path_cfg_keyboard='/opt/retropie/configs/all/keyboard'

if [[ $mode == '' ]]; then
    #[ -s /tmp/btcheck ] && mode='bluetooth' || [ $(ls /dev/input/js0 2> /dev/null) ] && mode='usb' || mode='keyboard'
    if [ -s /tmp/btcheck ]; then
        mode='bluetooth'
    elif [ $(ls /dev/input/js0 2> /dev/null) ]; then
        mode='usb'
    else
        mode='keyboard'
    fi
fi
#echo MODE: [ $mode ] 
 
function configure_retroarch() {
    #local cfg_index=6

    local cfg_current='/opt/retropie/configs/all/current/retroarch.cfg'
    local cfg_bluetooth="$path_cfg_bluetooth/retroarch.cfg"
    local cfg_usb="$path_cfg_usb/retroarch.cfg"
    local cfg_keyboard="$path_cfg_keyboard/retroarch.cfg"

    local array=($(echo $@ |sed 's/ /\n/g'))

    #GET --appendfile index
    for (( cfg_index = 0; cfg_index < ${#array[@]}; cfg_index++ )); do
       if [ "${array[$cfg_index]}" = "--appendconfig" ]; then
          break;
       fi
    done

    cfg_index=$(($cfg_index + 1))

    local cfg_default=${array[$cfg_index]}
    local path_cfg_default=$(echo $cfg_default | sed "s|/retroarch.cfg||g")

    echo "DEFAULT CONFIG FILE[$cfg_index]: [$cfg_default]"
    #echo "DEFAULT CONFIG FILE[$cfg_index]: [$cfg_default]" >> /opt/retropie/supplementary/runcommand/log.txt

    if [[ ! $cfg_default =~ .*%RETRO_CONFIG%.* ]]; then
        # APPEND CONFIG FILE
        [ -f $cfg_default ] && cat $cfg_default > $cfg_current

        if [ $mode == 'bluetooth' ]; then
            [ -f $path_cfg_default/bluetooth/retroarch.cfg ] && cfg_bluetooth=$path_cfg_default/bluetooth/retroarch.cfg
            echo "-- MODE BLUETOOTH ACTIVATED [$cfg_bluetooth] --" && cat $cfg_bluetooth >> $cfg_current
        elif [ $mode == 'usb' ]; then
            [ -f $path_cfg_default/usb/retroarch.cfg ] && cfg_usb=$path_cfg_default/usb/retroarch.cfg
            echo "-- MODE USB ACTIVATED [$cfg_usb] --" && cat $cfg_usb >> $cfg_current
        elif [ $mode == 'keyboard' ]; then
            [ -f $path_cfg_default/keyboard/retroarch.cfg ] && cfg_keyboard=$path_cfg_default/keyboard/retroarch.cfg
            echo "-- MODE KEYBOARD ACTIVATED [$cfg_keyboard] --" && cat $cfg_keyboard >> $cfg_current
        fi
    else
        # USE SPECIFIC CONFIG FILE
        [ $mode == 'bluetooth' ] && echo "-- MODE BLUETOOTH ACTIVATED --" && cfg_current=$(echo $cfg_default | sed "s|%RETRO_CONFIG%|$path_cfg_bluetooth|g")
        [ $mode == 'usb' ] && echo "-- MODE USB ACTIVATED --" && cfg_current=$(echo $cfg_default | sed "s|%RETRO_CONFIG%|$path_cfg_usb|g")
    fi

    [ -f $cfg_current ] && echo "CONFIG FILE: [$cfg_current]" && export command=$(echo $@ | sed "s|$cfg_default|$cfg_current|g")
}

function configure_pifba() {
    [ $mode == 'bluetooth' ] && echo "-- MODE BLUETOOTH ACTIVATED --" && sudo cp $path_cfg_bluetooth/fba2x-bluetooth.cfg /opt/retropie/emulators/pifba/fba2x.cfg
    [ $mode == 'usb' ] && echo "-- MODE USB ACTIVATED --" && sudo cp $path_cfg_usb/fba2x-usb.cfg /opt/retropie/emulators/pifba/fba2x.cfg
}

#CONFIGURE INPUT DEVICES
#echo "OLD COMMAND: [$@]"
#echo "OLD COMMAND: [$@]" > /opt/retropie/supplementary/runcommand/log.txt

[[ $(echo $@ | grep "/retroarch") ]] && configure_retroarch "$@"
[[ $(echo $@ | grep "/pifba") ]] && configure_pifba "$@" 

[[ $command == "" ]] && command=$@
#echo "NEW COMMAND: [$command]"
#echo "NEW COMMAND: [$command]" >> /opt/retropie/supplementary/runcommand/log.txt

