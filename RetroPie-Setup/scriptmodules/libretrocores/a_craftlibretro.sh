rp_module_id="a_craftlibretro"
rp_module_desc="CRAFT LibretroCore (Additional)"
rp_module_menus="4+"

function sources_a_craftlibretro() {
    gitPullOrClone "$rootdir/emulatorcores/craft-libretro" git://github.com/libretro/Craft.git
}

function build_a_craftlibretro() {
    pushd "$rootdir/emulatorcores/craft-libretro"

    # OVERRIDE MAKEFILE IF NECESSARY
    [ -f "$rootdir/makefiles/${FORMAT_COMPILER_TARGET}/craft-libretro/Makefile.libretro" ] && cp "$rootdir/makefiles/${FORMAT_COMPILER_TARGET}/craft-libretro/Makefile.libretro" .

    [ -z "${NOCLEAN}" ] && make -f Makefile.libretro clean
    make -f Makefile.libretro platform="${FORMAT_COMPILER_TARGET}" ${COMPILER} 2>&1 | tee makefile.log
    [ ${PIPESTATUS[0]} -ne 0 ] && __ERRMSGS="Could not successfully compile CRAFT LibretroCore!"
    [ -f makefile.log ] && cp makefile.log $outputdir/_log.makefile.craftlibretro

    popd
}

function configure_a_craftlibretro() {
    mkdir -p $romdir/craft
}

function copy_a_craftlibretro() {
    [ -z "$so_filter" ] && so_filter="*libretro*.so"
    find $rootdir/emulatorcores/craft-libretro/ -name $so_filter | xargs cp -t $outputdir
}
