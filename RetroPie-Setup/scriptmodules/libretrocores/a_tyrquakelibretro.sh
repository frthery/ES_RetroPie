rp_module_id="a_tyrquakelibretro"
rp_module_desc="QUAKE LibretroCore (Additional)"
rp_module_menus="2+"

function sources_a_tyrquakelibretro() {
    gitPullOrClone "$rootdir/emulatorcores/tyrquake-libretro" git://github.com/libretro/tyrquake.git
}

function build_a_tyrquakelibretro() {
    pushd "$rootdir/emulatorcores/tyrquake-libretro"

    # OVERRIDE MAKEFILE IF NECESSARY
    [ -f "$rootdir/makefiles/${FORMAT_COMPILER_TARGET}/tyrquake-libretro/Makefile" ] && cp "$rootdir/makefiles/${FORMAT_COMPILER_TARGET}/tyrquake-libretro/Makefile" .

    [ -z "${NOCLEAN}" ] && make -f Makefile clean
    make -f Makefile platform="${FORMAT_COMPILER_TARGET}" ${COMPILER} 2>&1 | tee makefile.log
    [ ${PIPESTATUS[0]} -ne 0 ] && __ERRMSGS="Could not successfully compile DOOM LibretroCore PRBOOM!"
    [ -f makefile.log ] && cp makefile.log $outputdir/_log.makefile.tyrquakelibretro

    popd
}

function copy_a_tyrquakelibretro() {
    [ -z "$so_filter" ] && so_filter="*libretro*.so"
    find $rootdir/emulatorcores/tyrquake-libretro/ -name $so_filter | xargs cp -t $outputdir
}