rp_module_id="a_mednafenpcelibretro"
rp_module_desc="PCE LibretroCore mednafen-pce (Additional)"
rp_module_menus="2+"

function sources_a_mednafenpcelibretro() {
    gitPullOrClone "$rootdir/emulatorcores/mednafen-pce-libretro/" git://github.com/petrockblog/mednafen-pce-libretro.git
}

function build_a_mednafenpcelibretro() {
    pushd "$rootdir/emulatorcores/mednafen-pce-libretro/"

    [ -z "${NOCLEAN}" ] && make -f Makefile clean
    make -f Makefile platform="${FORMAT_COMPILER_TARGET}" ${COMPILER} 2>&1 | tee makefile.log
    [ ${PIPESTATUS[0]} -ne 0 ] && __ERRMSGS="Could not successfully compile PCE LibretroCore mednafen-pce!"
    [ -f makefile.log ] && cp makefile.log $outputdir/_log.makefile.mednafenpcelibretro

    popd
}

function configure_a_mednafenpcelibretro() {
    mkdir -p $romdir/pcengine-libretro

    #rps_retronet_prepareConfig
    #setESSystem "TurboGrafx 16 (PC Engine)" "pcengine-libretro" "~/RetroPie/roms/pcengine-libretro" ".pce .PCE" "$rootdir/supplementary/runcommand/runcommand.sh 1 \"$rootdir/emulators/RetroArch/installdir/bin/retroarch -L `find $rootdir/emulatorcores/mednafen-pce-libretro/ -name \"*libretro*.so\" | head -1` --config $rootdir/configs/all/retroarch.cfg --appendconfig $rootdir/configs/pcengine/retroarch.cfg %ROM%\"" "pcengine" "pcengine"
}

function copy_a_mednafenpcelibretro() {
    [ -z "$so_filter" ] && so_filter="*libretro*.so"
    find $rootdir/emulatorcores/mednafen-pce-libretro/ -name $so_filter | xargs cp -t $outputdir
}