rp_module_id="pcsx_notaz"
rp_module_desc="Playstation 1 pcsx_rearmed"
rp_module_menus="2+"

#function depends_pcsx_notaz() {
#	rps_checkNeededPackages libpng-dev libsdl1.2-dev
#}

function sources_pcsx_notaz() {
    gitPullOrClone "$rootdir/emulators/pcsx_rearmed" git://github.com/notaz/pcsx_rearmed.git
}

function build_pcsx_notaz() {
    pushd "$rootdir/emulators/pcsx_rearmed"
    ./configure --sound-drivers=sdl
    make clean
    make
    popd
}

function configure_pcsx_notaz() {
    mkdir -p $romdir/psx

    #rps_retronet_prepareConfig
	#./pcsx -cdfile /home/pi/RidgeRacer/ridgeracer.cue
    #setESSystem "Sony Playstation 1" "psx" "~/RetroPie/roms/psx" ".img .IMG .7z .7Z .pbp .PBP .bin .BIN .cue .CUE" "$rootdir/supplementary/runcommand/runcommand.sh 1 \"$rootdir/emulators/RetroArch/installdir/bin/retroarch -L `find $rootdir/emulatorcores/pcsx_rearmed/ -name \"*libretro*.so\" | head -1` --config $rootdir/configs/all/retroarch.cfg --appendconfig $rootdir/configs/psx/retroarch.cfg %ROM%\"" "psx" "psx"
}