rp_module_id="a_dosboxlibretro"
rp_module_desc="DOSBOX LibretroCore (Additional)"
rp_module_menus="4+"

function sources_a_dosboxlibretro() {
    gitPullOrClone "$rootdir/emulatorcores/dosbox-libretro" git://github.com/libretro/dosbox-libretro
}

function build_a_dosboxlibretro() {
    pushd "$rootdir/emulatorcores/dosbox-libretro"

    [ -z "${NOCLEAN}" ] && make -f Makefile clean || echo "Failed to clean!"
    make -f Makefile platform="${FORMAT_COMPILER_TARGET}" ${COMPILER} 2>&1 | tee makefile.log
    [ ${PIPESTATUS[0]} -ne 0 ] && __ERRMSGS="Could not successfully compile DOSBOX LibretroCore!"
    [ -f makefile.log ] && cp makefile.log $outputdir/_log.makefile.dosboxlibretro

    popd
}

function configure_a_dosboxlibretro() {
    mkdir -p $romdir/dosbox
}

function copy_a_dosboxlibretro() {
    [ -z "$so_filter" ] && so_filter="*libretro*.so"
    find $rootdir/emulatorcores/dosbox-libretro/ -name $so_filter | xargs cp -t $outputdir
}
