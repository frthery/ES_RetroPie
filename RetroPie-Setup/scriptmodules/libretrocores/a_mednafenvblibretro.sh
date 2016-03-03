rp_module_id="a_mednafenvblibretro"
rp_module_desc="VB LibretroCore mednafen-vb (Additional)"
rp_module_menus="2+"

function sources_a_mednafenvblibretro() {
    gitPullOrClone "$rootdir/emulatorcores/mednafen-vb-libretro" git://github.com/libretro/beetle-vb-libretro.git
}

function build_a_mednafenvblibretro() {
    pushd "$rootdir/emulatorcores/mednafen-vb-libretro"

    # OVERRIDE MAKEFILE IF NECESSARY
    [ -f "$rootdir/makefiles/${FORMAT_COMPILER_TARGET}/mednafen-vb-libretro/Makefile" ] && cp "$rootdir/makefiles/${FORMAT_COMPILER_TARGET}/mednafen-vb-libretro/Makefile" .

    [ -z "${NOCLEAN}" ] && make -f Makefile clean || echo "Failed to clean!"
    make -f Makefile platform="${FORMAT_COMPILER_TARGET}" ${COMPILER} 2>&1 | tee makefile.log
    [ ${PIPESTATUS[0]} -ne 0 ] && __ERRMSGS="Could not successfully compile VB LibretroCore mednafen-vb!"
    [ -f makefile.log ] && cp makefile.log $outputdir/_log.makefile.mednafenvblibretro

    popd
}

function configure_a_mednafenvblibretro() {
    mkdir -p $romdir/vb

    #setESSystem "TurboGrafx 16 (PC Engine)" "pcengine" "~/RetroPie/roms/pcengine" ".pce .PCE" "$rootdir/supplementary/runcommand/runcommand.sh 1 \"$rootdir/emulators/RetroArch/installdir/bin/retroarch -L `find $rootdir/emulatorcores/mednafenpcefast/ -name \"*libretro*.so\" | head -1` --config $rootdir/configs/all/retroarch.cfg --appendconfig $rootdir/configs/pcengine/retroarch.cfg %ROM%\"" "pcengine" "pcengine"
}

function copy_a_mednafenvblibretro() {
    [ -z "$so_filter" ] && so_filter="*libretro*.so"
    find $rootdir/emulatorcores/mednafen-vb-libretro/ -name $so_filter | xargs cp -t $outputdir
}