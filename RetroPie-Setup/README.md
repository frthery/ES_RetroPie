build_retropie.sh
=================
A simple script for building, installing and configuring emulators and libretrocores.

- Install RetroPie-Setup "git clone --depth=1 https://github.com/RetroPie/RetroPie-Setup.git" 
- Install build_retropie.sh script into your RetroPie-Setup folder 
"wget -O https://raw.githubusercontent.com/frthery/ES_RetroPie/master/RetroPie-Setup/build_retropie.sh"
- Execute "sudo chmod 755 build_retropie.sh"

Get Latest Version:
- Command for updating your repository (get latest version of retropie's scripts) : "git pull"
- Command for updating modules : "./build_retropie.sh -u"

Usage:
======
build_retropie.sh [-u|--update] [-l|--list] [-a|--all] [-b|--build] [-i|--install] [-c|--configure] -name=[idx,?]

Commands:<br>
Updating current modules and listing them: ./build_retropie.sh -u -l<br>

Listing all modules: ./build_retropie.sh -l
./build_retropie.sh -l -name=list-all|emulators|libretrocores|supplementary<br/>

Build a module: ./build_retropie.sh -b -name=[idx]<br>
This command will build a specific module, result is dropped into ./bin folder.

Build/Install/Configure a module: ./build_retropie.sh -a -name=[idx]<br>
This command will execute all module's functions. (b:source and build functions, i:install function, c: configure function)
Some actions need more privileges, in this case execute this command with sudo.

Build a module for RPI: ./build_rpi.sh -rpi -name=[idx]<br>
or: ./build_retropie.sh -b -name=[idx]
This command will build a specific module for RPI platform.

Build a module for RPI2: ./build_rpi.sh -rpi2 -name=[idx]<br>
or: FORMAT_COMPILER_TARGET=armv7-cortexa7-hardfloat MAKEFLAGS=-j4 ./build_retropie.sh -b -name=[idx]
This command will build a specific module for RPI2 platform.

Build a module for POCKETCHIP: FORMAT_COMPILER_TARGET=armv7-cortexa8-hardfloat ./build_retropie.sh -b -name=[idx]<br>
This command will build a specific module for PocketCHIP platform. (need gcw-zero cygwin toolchain)

Build a module for GCW-ZERO: HOST_CC=mipsel-gcw0-linux MAKEFLAGS=-j4 ./build_retropie.sh -b -name=[idx]<br>
This command will build a specific module for GCW-ZERO platform.

Build a module for WIN64: ./build_win.sh -name=[idx]<br>
This command will build a specific module for WIN64 platform.
