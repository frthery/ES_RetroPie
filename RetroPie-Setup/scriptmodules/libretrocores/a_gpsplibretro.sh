rp_module_id="a_gpsplibretro"
rp_module_desc="GBA LibretroCore GPSP (Additional)"
rp_module_menus="2+"

function sources_a_gpsplibretro() {
    gitPullOrClone "$rootdir/emulatorcores/gpsp" git://github.com/libretro/gpsp.git
}

function build_a_gpsplibretro() {
    #rpSwap on 512

    pushd "$rootdir/emulatorcores/gpsp/"

    # OVERRIDE MAKEFILE IF NECESSARY
    [ -f "$rootdir/makefiles/${FORMAT_COMPILER_TARGET}/gpsp/Makefile" ] && cp "$rootdir/makefiles/${FORMAT_COMPILER_TARGET}/gpsp/Makefile" .

    [ -z "${NOCLEAN}" ] && make -f Makefile clean || echo "Failed to clean!"
    make -f Makefile platform="${FORMAT_COMPILER_TARGET}" ${COMPILER} 2>&1 | tee makefile.log
    [ ${PIPESTATUS[0]} -ne 0 ] && __ERRMSGS="Could not successfully compile GBA LibretroCore GPSP!"
    [ -f makefile.log ] && cp makefile.log $outputdir/_log.makefile.gpsplibretro

    popd

    #rpSwap off
}

function copy_a_gpsplibretro() {
    [ -z "$so_filter" ] && so_filter="*libretro*.so"
    find $rootdir/emulatorcores/gpsp/ -name $so_filter | xargs cp -t $outputdir
}