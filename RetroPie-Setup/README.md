build_retropie.sh
=================
A simple script for building, installing and configuring emulators and libretrocores.

- Place build_retropie.sh script into your RetroPie-Setup folder. 
- Execute "sudo chmod 755 build_libretro.sh".
- Execute "git pull" command for updating your repository.
- Execute "./build_retropie.sh -u" command to get new modules.

Usage:
======
build_retropie.sh [-u|--update] [-l|--list] [-a|--all] [-b|--build] [-i|--install] [-c|--configure] -name=[idx,?]

Samples:<br>
update current modules and listing them: ./build_retropie.sh -u -l<br>

listing all modules: ./build_retropie.sh -l

build a module: ./build_retropie.sh -b -name=[idx]<br>
This command will build a specific module, result is placed into ./bin folder.

execute a module: ./build_retropie.sh -a -name=[idx]<br>
This command will execute all module's functions. (b:source and build functions, i:install function, c: configure function)
Some actions need more privileges, in this case execute this command with sudo.

