rp_module_id="a_cap32libretro"
rp_module_desc="CPC6128 LibretroCore CAP32 (Additional)"
rp_module_menus="4+"

function sources_a_cap32libretro() {
    gitPullOrClone "$rootdir/emulatorcores/cap32-libretro" git://github.com/libretro/libretro-cap32.git
}

function build_a_cap32libretro() {
    pushd "$rootdir/emulatorcores/cap32-libretro"

    [ -z "${NOCLEAN}" ] && make -f Makefile clean || echo "Failed to clean!"
    make -f Makefile platform="${FORMAT_COMPILER_TARGET}" ${COMPILER} 2>&1 | tee makefile.log
    [ ${PIPESTATUS[0]} -ne 0 ] && __ERRMSGS="Could not successfully compile CPC6128 LibretroCore CAP32!"
    [ -f makefile.log ] && cp makefile.log $outputdir/_log.makefile.cap32libretro

    popd
}

function configure_a_cap32libretro() {
    mkdir -p $romdir/cpc
}

function copy_a_cap32libretro() {
    [ -z "$so_filter" ] && so_filter="*libretro*.so"
    find $rootdir/emulatorcores/cap32-libretro/ -name $so_filter | xargs cp -t $outputdir
}
