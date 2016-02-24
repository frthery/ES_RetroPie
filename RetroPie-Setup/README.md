build_retropie.sh
=================
A simple script for building, installing and configuring emulators and libretrocores.

- Install build_retropie.sh script into your RetroPie-Setup folder 
"wget https://github.com/frthery/ES_RetroPie/blob/master/RetroPie-Setup/build_retropie.sh"
- Execute "sudo chmod 755 build_retropie.sh"
- Execute "git pull" command for updating your repository (get latest version of retropie's scripts)
- Execute "./build_retropie.sh -u" command for updating modules

Usage:
======
build_retropie.sh [-u|--update] [-l|--list] [-a|--all] [-b|--build] [-i|--install] [-c|--configure] -name=[idx,?]

Commands:<br>
Updating current modules and listing them: ./build_retropie.sh -u -l<br>

Listing all modules: ./build_retropie.sh -l

Build a module: ./build_retropie.sh -b -name=[idx]<br>
This command will build a specific module, result is dropped into ./bin folder.

Build/Install/Configure a module: ./build_retropie.sh -a -name=[idx]<br>
This command will execute all module's functions. (b:source and build functions, i:install function, c: configure function)
Some actions need more privileges, in this case execute this command with sudo.

Build a module for RPI2: ./build_rpi.sh -rpi2 -name=[idx]<br>
This command will build a specific module for RPI2 platform.

Build a module for RPI: ./build_rpi.sh -rpi -name=[idx]<br>
This command will build a specific module for RPI platform.

Build a module for WIN64: ./build_win.sh -name=[idx]<br>
This command will build a specific module for WIN64 platform.

Build a module for GCW-ZERO: HOST_CC=mipsel-gcw0-linux MAKEFLAGS=-j4 ./build_retropie.sh -b -name=[idx]<br>
This command will build a specific module for GCW-ZERO platform.
