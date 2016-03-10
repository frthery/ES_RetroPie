rp_module_id="a_vecxlibretro"
rp_module_desc="Vectrex LibretroCore vecx (Additional)"
rp_module_menus="4+"

function sources_a_vecxlibretro() {
    gitPullOrClone "$rootdir/emulatorcores/vecx-libretro" git://github.com/libretro/libretro-vecx.git
}

function build_a_vecxlibretro() {
    pushd "$rootdir/emulatorcores/vecx-libretro"

    [ -z "${NOCLEAN}" ] && make -f Makefile.libretro clean
    make -f Makefile.libretro platform="${FORMAT_COMPILER_TARGET}" ${COMPILER} 2>&1 | tee makefile.log
    [ ${PIPESTATUS[0]} -ne 0 ] && __ERRMSGS="Could not successfully compile Vectrex LibretroCore vecx!"
    [ -f makefile.log ] && cp makefile.log $outputdir/_log.makefile.vecxlibretro

    popd
}

function configure_a_vecxlibretro() {
    mkdir -p $romdir/vectrex
}

function copy_a_vecxlibretro() {
    [ -z "$so_filter" ] && so_filter="*libretro*.so"
    find $rootdir/emulatorcores/vecx-libretro/ -name $so_filter | xargs cp -t $outputdir
}
