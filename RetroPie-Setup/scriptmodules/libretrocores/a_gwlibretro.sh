rp_module_id="a_gwlibretro"
rp_module_desc="GW LibretroCore game & watch (Additional)"
rp_module_menus="4+"

function sources_a_gwlibretro() {
    gitPullOrClone "$rootdir/emulatorcores/gw-libretro" git://github.com/libretro/gw-libretro
}

function build_a_gwlibretro() {
    pushd "$rootdir/emulatorcores/gw-libretro"

    [ -z "${NOCLEAN}" ] && make -f Makefile.libretro clean || echo "Failed to clean!"
    make -f Makefile.libretro platform="${FORMAT_COMPILER_TARGET}" ${COMPILER} 2>&1 | tee makefile.log
    [ ${PIPESTATUS[0]} -ne 0 ] && __ERRMSGS="Could not successfully compile GW LibretroCore gw!"
    [ -f makefile.log ] && cp makefile.log $outputdir/_log.makefile.gwlibretro

    popd
}

function configure_a_gwlibretro() {
    mkdir -p $romdir/gw
}

function copy_a_gwlibretro() {
    [ -z "$so_filter" ] && so_filter="*libretro*.so"
    find $rootdir/emulatorcores/gw-libretro/ -name $so_filter | xargs cp -t $outputdir
}
