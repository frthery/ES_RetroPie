#!/bin/bash
clear

FBCP_PID=$(ps -eo pid,command | grep "/bin/bash fbcp" | grep -v grep | awk '{print $1}')
SERVER_IP='192.168.0.15'
OPT_CUSTOM=0
OPT_720=0
OPT_1080=0
OPT_MAP=0
OPT_FBCP=0
MOONLIGHT_ARGS=''

while [ "$1" != "" ]; do
    PARAM=`echo $1 | awk -F= '{print $1}'`
    VALUE=`echo $1 | awk -F= '{print $2}'`
    case $PARAM in
        -h | --help)
            #usage
            exit
            ;;
        -720)
            OPT_720=1
            MOONLIGHT_ARGS+='-720 -60fps '
            ;;
        -1080)
            OPT_1080=1
            MOONLIGHT_ARGS+='-1080 -60fps '
            ;;
        -custom)
            OPT_CUSTOM=1
            MOONLIGHT_ARGS+='-width 720 -height 483 -60fps '
            ;;
        -map)
            OPT_MAP=1
            MOONLIGHT_ARGS+='-input /dev/input/event0 -mapping default.map '
            ;;
        -fbcp)
            OPT_FBCP=1
            ;;
        *)
            echo "[ERROR] unknown parameter \"$PARAM\""
            #usage
            exit 1
            ;;
    esac
    shift
done

if [ $OPT_FBCP -eq 1 ] && [ -z "$FBCP_PID" ]; then
   echo '[STARTING] FBCP...'
   fbcp &
   con2fbmap 1 0
fi

echo '[STARTING] moonlight...'
cmd='moonlight '$OPT_ARGS' stream -app Steam '$SERVER_IP
eval "$cmd"

if [ $OPT_FBCP -eq 1 ]; then
   echo '[STOPING] FBCP...'
   killall fbcp > /dev/null
   con2fbmap 1 1
fi

clear
exit 0
