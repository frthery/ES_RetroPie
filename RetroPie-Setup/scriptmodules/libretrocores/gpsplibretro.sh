rp_module_id="gpsplibretro"
rp_module_desc="GBA LibretroCore gpsp"
rp_module_menus="2+"

function sources_gpsplibretro() {
    gitPullOrClone "$rootdir/emulatorcores/gpsp" https://github.com/libretro/gpsp.git
}

function build_gpsplibretro() {
    #rpSwap on 256 240

    pushd "$rootdir/emulatorcores/gpsp/"

    [ -z "${NOCLEAN}" ] && make -f Makefile clean || echo "Failed to clean [code=$?] !"
    make -f Makefile platform="${FORMAT_COMPILER_TARGET}" ${COMPILER} || echo "Failed to build [code=$?] !"

    [ -z "$so_filter" ] && so_filter="*libretro*.so"
    if [[ -z `find $rootdir/emulatorcores/gpsp/ -name "$so_filter"` ]]; then
        __ERRMSGS="$__ERRMSGS Could not successfully compile GPSP core."
    fi

    popd

    #rpSwap off
}

function configure_gpsplibretro() {
    mkdir -p $romdir/gba

    #rps_retronet_prepareConfig
    #setESSystem "Gameboy Advance" "gba" "~/RetroPie/roms/gba" ".gba .GBA" "$rootdir/supplementary/runcommand/runcommand.sh 2 \"$rootdir/emulators/RetroArch/installdir/bin/retroarch -L `find $rootdir/emulatorcores/gpsp/ -name \"*libretro*.so\" | head -1` --config $rootdir/configs/all/retroarch.cfg --appendconfig $rootdir/configs/gpsp/retroarch.cfg $__tmpnetplaymode$__tmpnetplayhostip_cfile$__tmpnetplayport$__tmpnetplayframes %ROM%\"" "gba" "gba"
}

function copy_gpsplibretro() {
    [ -z "$so_filter" ] && so_filter="*libretro*.so"
    find $rootdir/emulatorcores/gpsp/ -name $so_filter | xargs cp -t ./bin
}