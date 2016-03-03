rp_module_id="a_fbacoresneolibretro"
rp_module_desc="LYNX LibretroCore mednafen-lynx (Additional)"
rp_module_menus="2+"

function sources_a_fbacoresneolibretro() {
    gitPullOrClone "$rootdir/emulatorcores/fba-cores-neo" git://github.com/libretro/fba_cores_neo.git
}

function build_a_fbacoresneolibretro() {
    pushd "$rootdir/emulatorcores/fba-cores-neo"

    # OVERRIDE MAKEFILE IF NECESSARY
    [ -f "$rootdir/makefiles/${FORMAT_COMPILER_TARGET}/fba-cores-neo/Makefile" ] && cp "$rootdir/makefiles/${FORMAT_COMPILER_TARGET}/fba-cores-neo/Makefile" .

    [ -z "${NOCLEAN}" ] && make -f Makefile clean || echo "Failed to clean!"
    make -f Makefile platform="${FORMAT_COMPILER_TARGET}" ${COMPILER} 2>&1 | tee makefile.log
    [ ${PIPESTATUS[0]} -ne 0 ] && __ERRMSGS="Could not successfully compile FBA NEO LibretroCore fbaneo!"
    [ -f makefile.log ] && cp makefile.log $outputdir/_log.makefile.mednafenlynxlibretro

    popd
}

function configure_a_fbacoresneolibretro() {
    mkdir -p $romdir/neogeo

    #setESSystem "TurboGrafx 16 (PC Engine)" "pcengine" "~/RetroPie/roms/pcengine" ".pce .PCE" "$rootdir/supplementary/runcommand/runcommand.sh 1 \"$rootdir/emulators/RetroArch/installdir/bin/retroarch -L `find $rootdir/emulatorcores/mednafenpcefast/ -name \"*libretro*.so\" | head -1` --config $rootdir/configs/all/retroarch.cfg --appendconfig $rootdir/configs/pcengine/retroarch.cfg %ROM%\"" "pcengine" "pcengine"
}

function copy_a_fbacoresneolibretro() {
    [ -z "$so_filter" ] && so_filter="*libretro*.so"
    find $rootdir/emulatorcores/fba-cores-neo/ -name $so_filter | xargs cp -t $outputdir
}