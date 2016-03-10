rp_module_id="a_mednafenlynxlibretro"
rp_module_desc="LYNX LibretroCore mednafen-lynx (Additional)"
rp_module_menus="2+"

function sources_a_mednafenlynxlibretro() {
    gitPullOrClone "$rootdir/emulatorcores/mednafen-lynx-libretro" git://github.com/libretro/beetle-lynx-libretro.git
}

function build_a_mednafenlynxlibretro() {
    pushd "$rootdir/emulatorcores/mednafen-lynx-libretro"

    # OVERRIDE MAKEFILE IF NECESSARY
    [ -f "$rootdir/makefiles/${FORMAT_COMPILER_TARGET}/mednafen-lynx-libretro/Makefile" ] && cp "$rootdir/makefiles/${FORMAT_COMPILER_TARGET}/mednafen-lynx-libretro/Makefile" .

    [ -z "${NOCLEAN}" ] && make -f Makefile clean || echo "Failed to clean!"
    make -f Makefile platform="${FORMAT_COMPILER_TARGET}" ${COMPILER} 2>&1 | tee makefile.log
    [ ${PIPESTATUS[0]} -ne 0 ] && __ERRMSGS="Could not successfully compile LYNX LibretroCore mednafen-lynx!"
    [ -f makefile.log ] && cp makefile.log $outputdir/_log.makefile.mednafenlynxlibretro

    popd
}

function configure_a_mednafenlynxlibretro() {
    mkdir -p $romdir/lynx
}

function copy_a_mednafenlynxlibretro() {
    [ -z "$so_filter" ] && so_filter="*libretro*.so"
    find $rootdir/emulatorcores/mednafen-lynx-libretro/ -name $so_filter | xargs cp -t $outputdir
}