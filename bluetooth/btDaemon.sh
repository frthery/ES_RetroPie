#!/bin/bash

#sudo apt-get install bluetooth bluez-utils blueman bluez-compat
# CONFIGURE YOUR BLUETOOTH DEVICES
BT1='65:03:36:63:04:07'
#BT2='48:72:50:EA:49:81'

# FUNCTIONS
logger() {
   #no logger
   [ $NO_LOG -eq 1 ] && return
   [[ $2 -eq 1 ]] && COUNT_LINES_LOGGER=0

   COUNT_LINES_LOGGER=$(($COUNT_LINES_LOGGER + 1))

   now=$(date +"%m-%d-%y %r")
   if [ $VERBOSE -eq 1 ]; then
      echo "[$now]" $1
   fi

   if [[ $2 -eq 1 ]]; then
      #RESET Logger File
      echo "[$now]" $1 > $LOGGER_FILE
   else
      echo "[$now]" $1 >> $LOGGER_FILE
   fi
}

auto_connect() {
   local index=$1
   local bt=$2

   [ ! -s /tmp/btcheck ] && [ $(ls /dev/input/js0 2> /dev/null) ] && logger "USB device js0 is already connected" && return

   if [ ! -z "$bt" ]; then
      if grep -q $bt /tmp/btcheck; then
         logger "[OK] bluetooth device $index [$bt] is already connected"
      else
         logger "[KO] bluetooth device $index [$bt] not connected"
         connect $index $bt
      fi
   else
      logger "no configuration found for bluetooth device $index (check mac address)"
   fi
}

connect() {
   local index=$1
   local bt=$2
   local btStatus='notconnected'

   local tryPing=1
   local tryCon=1
   local maxRetry=1
   #priority to gamepad 1
   #[ $index -eq 0 ] && maxRetry=10

   logger "try connecting bluetooth device $index [$bt] maxRetry=$maxRetry..."

   #10 attempts for connecting device
   while [ $tryPing -le $maxRetry ]; do
      sudo l2ping $bt -c 1 > /dev/null 2>&1
      RESPING=$?
      if [ $RESPING = 0 ]; then
         logger "[OK][$RESPING] ping bluetooth device $index [$bt]"

         tryCon=1
         while [ $tryCon -le $maxRetry ]; do
            #sudo bluez-test-input connect $bt &> /dev/null
            hidd --connect $bt &> /dev/null
            RESCON=$?
            if [ $RESCON = 0 ]; then
               #logger "[OK][$RESCON] bluetooth device $index [$bt] connected"
               btStatus='connected'
            else
               logger "[KO][$RESCON][$tryCon] bluetooth device $index [$bt] connected"
               btStatus='notconnected'
            fi

            [ $btStatus = 'connected' ] && break
            tryCon=$(($tryCon + 1))
         done
      else
         logger "[KO][$RESPING][$tryPing] ping bluetooth device $index [$bt]"
         btStatus='noping'
      fi

      [ $btStatus = 'connected' ] && break
      tryPing=$(($tryPing + 1))
   done

   [ $index -eq 0 ] && BT1_STATUS=$btStatus && logger "bluetooth device $index [$bt] [$BT1_STATUS]"
   [ $index -eq 1 ] && BT2_STATUS=$btStatus && logger "bluetooth device $index [$bt] [$BT2_STATUS]"
}
# END FUNCTIONS

# GLOBAL VARIABLES
BT1_STATUS='unknown'
BT2_STATUS='unknown'

VERBOSE=0
NO_LOG=0
COUNT_LINES_LOGGER=0
MAX_LINES_LOGGER=100
DELAI=10
LOGGER_FILE=/var/log/btDaemonLogger.log
[ "$1" = '-v' ] && VERBOSE=1
# END GLOBAL VARIABLES

# MAIN
logger "[START] bluetooth devices monitoring..." 1

while [ 1 ]; do
   #COUNT_LINES_LOGGER=$(wc -l $LOGGER_FILE | cut -f1 -d" ")
   if [ $COUNT_LINES_LOGGER -gt $MAX_LINES_LOGGER ]; then
      #RESET Logger
      logger "--- bluetooth devices check connections [delai=$DELAI] ---" 1
   else
      logger "--- bluetooth devices check connections [delai=$DELAI] ---"
   fi

   #check bluetooth devices status
   #hcitool con|grep -v "^Connections:" > /tmp/btcheck
   hidd --show > /tmp/btcheck

   auto_connect 0 $BT1
   auto_connect 1 $BT2

   logger "------------------------------------------------------"
   sleep $DELAI
done

logger "[STOP] bluetooth devices monitoring."
# END MAIN

exit 0

