rp_module_id="a_fbacorescps2libretro"
rp_module_desc="CPS2 LibretroCore cps1(Additional)"
rp_module_menus="2+"

function sources_a_fbacorescps2libretro() {
    gitPullOrClone "$rootdir/emulatorcores/fba-cores-cps2" git://github.com/libretro/fba_cores_cps2.git
}

function build_a_fbacorescps2libretro() {
    pushd "$rootdir/emulatorcores/fba-cores-cps2"

    # OVERRIDE MAKEFILE IF NECESSARY
    [ -f "$rootdir/makefiles/${FORMAT_COMPILER_TARGET}/fba-cores-cps2/makefile.libretro" ] && cp "$rootdir/makefiles/${FORMAT_COMPILER_TARGET}/fba-cores-cps2/makefile.libretro" .

    [ -z "${NOCLEAN}" ] && make -f makefile.libretro clean || echo "Failed to clean!"
    make -f makefile.libretro platform="${FORMAT_COMPILER_TARGET}" ${COMPILER} 2>&1 | tee makefile.log
    [ ${PIPESTATUS[0]} -ne 0 ] && __ERRMSGS="Could not successfully compile FBA CPS2 LibretroCore fbacps1!"
    [ -f makefile.log ] && cp makefile.log $outputdir/_log.makefile.fbacps2libretro

    popd
}

function configure_a_fbacorescps2libretro() {
    mkdir -p $romdir/cps2

    #setESSystem "TurboGrafx 16 (PC Engine)" "pcengine" "~/RetroPie/roms/pcengine" ".pce .PCE" "$rootdir/supplementary/runcommand/runcommand.sh 1 \"$rootdir/emulators/RetroArch/installdir/bin/retroarch -L `find $rootdir/emulatorcores/mednafenpcefast/ -name \"*libretro*.so\" | head -1` --config $rootdir/configs/all/retroarch.cfg --appendconfig $rootdir/configs/pcengine/retroarch.cfg %ROM%\"" "pcengine" "pcengine"
}

function copy_a_fbacorescps2libretro() {
    [ -z "$so_filter" ] && so_filter="*libretro*.so"
    find $rootdir/emulatorcores/fba-cores-cps2/ -name $so_filter | xargs cp -t $outputdir
}