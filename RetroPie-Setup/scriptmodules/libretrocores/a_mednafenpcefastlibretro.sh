rp_module_id="a_mednafenpcefastlibretro"
rp_module_desc="PCE LibretroCore mednafen-pce-fast (Additional)"
rp_module_menus="2+"

function sources_a_mednafenpcefastlibretro() {
    gitPullOrClone "$rootdir/emulatorcores/mednafen-pce-fast-libretro" git://github.com/libretro/beetle-pce-fast-libretro.git
}

function build_a_mednafenpcefastlibretro() {
    pushd "$rootdir/emulatorcores/mednafen-pce-fast-libretro"

    # OVERRIDE MAKEFILE IF NECESSARY
    [ -f "$rootdir/makefiles/${FORMAT_COMPILER_TARGET}/mednafen-pce-fast-libretro/Makefile" ] && cp "$rootdir/makefiles/${FORMAT_COMPILER_TARGET}/mednafen-pce-fast-libretro/Makefile" .

    [ ${FORMAT_COMPILER_TARGET} == "armv6j-hardfloat" ] && FORMAT_COMPILER_TARGET="rpi1"

    [ -z "${NOCLEAN}" ] && make -f Makefile clean || echo "Failed to clean!"
    make -f Makefile platform="${FORMAT_COMPILER_TARGET}" ${COMPILER} 2>&1 | tee makefile.log
    [ ${PIPESTATUS[0]} -ne 0 ] && __ERRMSGS="Could not successfully compile PCE LibretroCore mednafen-pce-fast!"
    [ -f makefile.log ] && cp makefile.log $outputdir/_log.makefile.mednafenpcefastlibretro

    popd
}

function copy_a_mednafenpcefastlibretro() {
    [ -z "$so_filter" ] && so_filter="*libretro*.so"
    find $rootdir/emulatorcores/mednafen-pce-fast-libretro/ -name $so_filter | xargs cp -t $outputdir
}