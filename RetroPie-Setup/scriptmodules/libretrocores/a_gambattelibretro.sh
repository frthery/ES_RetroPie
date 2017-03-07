rp_module_id="a_gambattelibretro"
rp_module_desc="Gameboy Color LibretroCore Gambatte (Additional)"
rp_module_menus="2+"

function sources_a_gambattelibretro() {
    gitPullOrClone "$rootdir/emulatorcores/gambatte-libretro" git://github.com/libretro/gambatte-libretro.git
}

function build_a_gambattelibretro() {
    pushd "$rootdir/emulatorcores/gambatte-libretro/libgambatte"

    # OVERRIDE MAKEFILE IF NECESSARY
    [ -f "$rootdir/makefiles/${FORMAT_COMPILER_TARGET}/gambatte-libretro/libgambatte/Makefile.libretro" ] && cp "$rootdir/makefiles/${FORMAT_COMPILER_TARGET}/gambatte-libretro/libgambatte/Makefile.libretro" .

    [ -z "${NOCLEAN}" ] && make -f Makefile.libretro clean || echo "Failed to clean!"
    make -f Makefile.libretro platform="${FORMAT_COMPILER_TARGET}" ${COMPILER} 2>&1 | tee makefile.log
    [ ${PIPESTATUS[0]} -ne 0 ] && __ERRMSGS="Could not successfully compile Gameboy Color LibretroCore Gambatte!"
    [ -f makefile.log ] && cp makefile.log $outputdir/_log.makefile.gambattelibretro

    popd
}

function copy_a_gambattelibretro() {
    [ -z "$so_filter" ] && so_filter="*libretro*.so"
    find $rootdir/emulatorcores/gambatte-libretro/ -name $so_filter | xargs cp -t $outputdir
}