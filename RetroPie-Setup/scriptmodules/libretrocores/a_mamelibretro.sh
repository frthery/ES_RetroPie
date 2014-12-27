rp_module_id="a_mamelibretro"
rp_module_desc="MAME LibretroCore (Additional)"
rp_module_menus="2+"

function sources_a_mamelibretro() {
    gitPullOrClone "$rootdir/emulatorcores/mame-libretro" git://github.com/libretro/mame.git
}

function build_a_mamelibretro() {
    pushd "$rootdir/emulatorcores/mame-libretro"

    [ -z "${NOCLEAN}" ] && make -f Makefile.libretro clean || echo "Failed to clean!"
    make -f Makefile.libretro platform="${FORMAT_COMPILER_TARGET}" ${COMPILER} 2>&1 | tee makefile.log
    [ ${PIPESTATUS[0]} -ne 0 ] && __ERRMSGS="Could not successfully compile MAME LibretroCore!"
    [ -f makefile.log ] && cp makefile.log $outputdir/_log.makefile.mamelibretro

    #make TARGET=mess

    popd
}

function configure_a_mamelibretro() {
    mkdir -p $romdir/mame-libretro

    setESSystem "MAME" "mame-libretro" "~/RetroPie/roms/mame-libretro" ".zip .ZIP" "$rootdir/emulators/RetroArch/installdir/bin/retroarch -L `find $rootdir/emulatorcores/imame4all-libretro/ -name \"*libretro*.so\" | head -1` --config $rootdir/configs/all/retroarch.cfg --appendconfig $rootdir/configs/mame/retroarch.cfg %ROM%" "arcade" "mame"
}

function copy_a_mamelibretro() {
    [ -z "$so_filter" ] && so_filter="*libretro*.so"
    find $rootdir/emulatorcores/mame-libretro/ -name $so_filter | xargs cp -t $outputdir
}