build_retropie.sh
=================
A simple script for building, installing and configuring emulators and libretrocores.

- Put build_retropie.sh script into your RetroPie-Setup folder 
"wget https://github.com/frthery/ES_RetroPie/blob/master/RetroPie-Setup/build_retropie.sh"
- Execute "sudo chmod 755 build_retropie.sh".
- Execute "git pull" command for updating your repository (get retropie latest version).
- Execute "./build_retropie.sh -u" command to get latest modules.

Usage:
======
build_retropie.sh [-u|--update] [-l|--list] [-a|--all] [-b|--build] [-i|--install] [-c|--configure] -name=[idx,?]

Commands Samples:<br>
Updating current modules and listing them: ./build_retropie.sh -u -l<br>

Listing all modules: ./build_retropie.sh -l

Build a module: ./build_retropie.sh -b -name=[idx]<br>
This command will build a specific module, result is placed into ./bin folder.

Build/Install/Configure a module: ./build_retropie.sh -a -name=[idx]<br>
This command will execute all module's functions. (b:source and build functions, i:install function, c: configure function)
Some actions need more privileges, in this case execute this command with sudo.

Build a module on RPI2: ./build_rpi.sh -rpi2 -name=[idx]<br>
This command will build a specific module for RPI2 platform.

Build a module on RPI: ./build_rpi.sh -rpi -name=[idx]<br>
This command will build a specific module for RPI platform.

Build a module on WIN64: ./build_win.sh -name=[idx]<br>
This command will build a specific module for WIN64 platform.

