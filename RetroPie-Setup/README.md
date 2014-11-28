build_libretro.sh
=================
A simple script for building, installing and configuring emulators and libretrocores.

- Place build_libretro.sh script into your RetroPie-Setup folder. 
- Execute "sudo chmod 755 build_libretro.sh" for giving good permissions.
- Execute "git pull" command for updating your repository.
- Copy new libretrocores scripts into your ./scriptmodules/libretrocores folder.

Usage:
======
build_libretro.sh [-l|--list] [-a|--all] [-b|--build] [-i|--install] [-c|--configure] -name=[idx]

Samples:<br>
listing all modules: ./build_libretro.sh -l

build module: ./build_libretro.sh -b -name=[idx]<br>
This command will build a specific module, result is placed into ./bin folder.

execute module: ./build_libretro.sh -a -name=[idx]<br>
This command will execute all module's functions. (b:build and source functions, i:install function, c: configure function)

