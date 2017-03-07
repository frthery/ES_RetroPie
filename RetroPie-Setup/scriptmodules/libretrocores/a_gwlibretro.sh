rp_module_id="a_gwlibretro"
rp_module_desc="Game & Watch LibretroCore (Additional)"
rp_module_menus="4+"

function sources_a_gwlibretro() {
    gitPullOrClone "$rootdir/emulatorcores/gw-libretro" git://github.com/libretro/gw-libretro
}

function build_a_gwlibretro() {
    pushd "$rootdir/emulatorcores/gw-libretro"

    # OVERRIDE MAKEFILE IF NECESSARY
    [ -f "$rootdir/makefiles/${FORMAT_COMPILER_TARGET}/gw-libretro/Makefile.libretro" ] && cp "$rootdir/makefiles/${FORMAT_COMPILER_TARGET}/gw-libretro/Makefile.libretro" .

    [ -z "${NOCLEAN}" ] && make -f Makefile.libretro clean || echo "Failed to clean!"
    make -f Makefile.libretro platform="${FORMAT_COMPILER_TARGET}" ${COMPILER} 2>&1 | tee makefile.log
    [ ${PIPESTATUS[0]} -ne 0 ] && __ERRMSGS="Could not successfully compile Game & Watch LibretroCore!"
    [ -f makefile.log ] && cp makefile.log $outputdir/_log.makefile.gwlibretro

    popd
}

function copy_a_gwlibretro() {
    [ -z "$so_filter" ] && so_filter="*libretro*.so"
    find $rootdir/emulatorcores/gw-libretro/ -name $so_filter | xargs cp -t $outputdir
}
