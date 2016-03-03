rp_module_id="a_mednafenngplibretro"
rp_module_desc="NGP LibretroCore mednafen-ngp (Additional)"
rp_module_menus="2+"

function sources_a_mednafenngplibretro() {
    gitPullOrClone "$rootdir/emulatorcores/mednafen-ngp-libretro" git://github.com/libretro/beetle-ngp-libretro.git
}

function build_a_mednafenngplibretro() {
    pushd "$rootdir/emulatorcores/mednafen-ngp-libretro"

    # OVERRIDE MAKEFILE IF NECESSARY
    [ -f "$rootdir/makefiles/${FORMAT_COMPILER_TARGET}/mednafen-ngp-libretro/Makefile" ] && cp "$rootdir/makefiles/${FORMAT_COMPILER_TARGET}/mednafen-ngp-libretro/Makefile" .

    [ -z "${NOCLEAN}" ] && make -f Makefile clean || echo "Failed to clean!"
    make -f Makefile platform="${FORMAT_COMPILER_TARGET}" ${COMPILER} 2>&1 | tee makefile.log
    [ ${PIPESTATUS[0]} -ne 0 ] && __ERRMSGS="Could not successfully compile NGP LibretroCore mednafen-ngp!"
    [ -f makefile.log ] && cp makefile.log $outputdir/_log.makefile.mednafenngplibretro

    popd
}

function configure_a_mednafenngplibretro() {
    mkdir -p $romdir/ngp

    #setESSystem "TurboGrafx 16 (PC Engine)" "pcengine" "~/RetroPie/roms/pcengine" ".pce .PCE" "$rootdir/supplementary/runcommand/runcommand.sh 1 \"$rootdir/emulators/RetroArch/installdir/bin/retroarch -L `find $rootdir/emulatorcores/mednafenpcefast/ -name \"*libretro*.so\" | head -1` --config $rootdir/configs/all/retroarch.cfg --appendconfig $rootdir/configs/pcengine/retroarch.cfg %ROM%\"" "pcengine" "pcengine"
}

function copy_a_mednafenngplibretro() {
    [ -z "$so_filter" ] && so_filter="*libretro*.so"
    find $rootdir/emulatorcores/mednafen-ngp-libretro/ -name $so_filter | xargs cp -t $outputdir
}