#!/bin/bash

echo '[KILLALL] FBCP...'
killall fbcp > /dev/null
con2fbmap 1 1

clear
exit 0
