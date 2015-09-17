AutoConnect bluetooth devices
==============================

btDaemon.sh : Script for auto connecting bluetooth devices (should be placed into /home/pi/ folder, change BT1 and BT2 values with yours gamepads mac address)<br>
btService : Service for managing btDaemon.sh (start|stop|status)

How to Install Service:
sudo mv btService /etc/init.d
sudo update-rc.d btService defaults
