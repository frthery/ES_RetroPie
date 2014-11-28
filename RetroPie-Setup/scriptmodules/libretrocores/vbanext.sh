rp_module_id="vbanext"
rp_module_desc="GBA LibretroCore vbanext"
rp_module_menus="2+"

function sources_vbanext() {
    gitPullOrClone "$rootdir/emulatorcores/vbanext" https://github.com/libretro/vba-next
}

function build_vbanext() {
    pushd "$rootdir/emulatorcores/vbanext/"
    make -f Makefile.libretro clean
	#make -f Makefile.libretro platform=armvhardfloat
	make -f Makefile.libretro
    popd
    if [[ -z `find $rootdir/emulatorcores/vbanext/ -name "*libretro*.so"` ]]; then
        __ERRMSGS="$__ERRMSGS Could not successfully compile YABAUSE core."
    fi
}

function configure_vbanext() {
    mkdir -p $romdir/vbanext

    #rps_retronet_prepareConfig
    #setESSystem "Gameboy Advance" "gba" "~/RetroPie/roms/gba" ".gba .GBA" "$rootdir/supplementary/runcommand/runcommand.sh 2 \"$rootdir/emulators/RetroArch/installdir/bin/retroarch -L `find $rootdir/emulatorcores/vbanext/ -name \"*libretro*.so\" | head -1` --config $rootdir/configs/all/retroarch.cfg --appendconfig $rootdir/configs/vbanext/retroarch.cfg $__tmpnetplaymode$__tmpnetplayhostip_cfile$__tmpnetplayport$__tmpnetplayframes %ROM%\"" "gba" "gba"
}