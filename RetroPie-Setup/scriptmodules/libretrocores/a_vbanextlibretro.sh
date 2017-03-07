rp_module_id="a_vbanextlibretro"
rp_module_desc="GBA LibretroCore VbaNext (Additional)"
rp_module_menus="2+"

function sources_a_vbanextlibretro() {
    gitPullOrClone "$rootdir/emulatorcores/vba-next" git://github.com/libretro/vba-next
}

function build_a_vbanextlibretro() {
    pushd "$rootdir/emulatorcores/vba-next/"

    [ -z "${NOCLEAN}" ] && make -f Makefile.libretro clean
    make -f Makefile.libretro platform="${FORMAT_COMPILER_TARGET}" ${COMPILER} 2>&1 | tee makefile.log
    [ ${PIPESTATUS[0]} -ne 0 ] && __ERRMSGS="Could not successfully compile GBA LibretroCore VbaNext!"
    [ -f makefile.log ] && cp makefile.log $outputdir/_log.makefile.vbanextlibretro

    popd
}

function copy_a_vbanextlibretro() {
    [ -z "$so_filter" ] && so_filter="*libretro*.so"
    find $rootdir/emulatorcores/vba-next/ -name $so_filter | xargs cp -t $outputdir
}