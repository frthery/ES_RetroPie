rp_module_id="a_mame2000libretro"
rp_module_desc="MAME 2010 LibretroCore (Additional)"
rp_module_menus="2+"

function sources_a_mame2000libretro() {
    gitPullOrClone "$rootdir/emulatorcores/mame2000-libretro" git://github.com/libretro/mame2000-libretro.git
}

function build_a_mame2000libretro() {
    pushd "$rootdir/emulatorcores/mame2000-libretro"

    # OVERRIDE MAKEFILE IF NECESSARY
    [ -f "$rootdir/makefiles/${FORMAT_COMPILER_TARGET}/mame2000-libretro/Makefile" ] && cp "$rootdir/makefiles/${FORMAT_COMPILER_TARGET}/mame2000-libretro/Makefile" .

    [ -z "${NOCLEAN}" ] && make -f makefile clean
    make -f Makefile platform="${FORMAT_COMPILER_TARGET}" ${COMPILER} 2>&1 | tee makefile.log
    [ ${PIPESTATUS[0]} -ne 0 ] && __ERRMSGS="Could not successfully compile iMAME4all LibretroCore!"
    [ -f makefile.log ] && cp makefile.log $outputdir/_log.makefile.mame2010libretro

    popd
}

function configure_a_mame2000libretro() {
    mkdir -p $romdir/mame-libretro

    #setESSystem "MAME" "mame-libretro" "~/RetroPie/roms/mame-libretro" ".zip .ZIP" "$rootdir/emulators/RetroArch/installdir/bin/retroarch -L `find $rootdir/emulatorcores/imame4all-libretro/ -name \"*libretro*.so\" | head -1` --config $rootdir/configs/all/retroarch.cfg --appendconfig $rootdir/configs/mame/retroarch.cfg %ROM%" "arcade" "mame"
}

function copy_a_mame2000libretro() {
    [ -z "$so_filter" ] && so_filter="*libretro*.so"
    find $rootdir/emulatorcores/mame2000-libretro/ -name $so_filter | xargs cp -t $outputdir
}