rp_module_id="a_mednafenwswanlibretro"
rp_module_desc="WSWAN LibretroCore mednafen-wswan (Additional)"
rp_module_menus="2+"

function sources_a_mednafenwswanlibretro() {
    gitPullOrClone "$rootdir/emulatorcores/mednafen-wswan-libretro" git://github.com/libretro/beetle-wswan-libretro.git
}

function build_a_mednafenwswanlibretro() {
    pushd "$rootdir/emulatorcores/mednafen-wswan-libretro"

    # OVERRIDE MAKEFILE IF NECESSARY
    [ -f "$rootdir/makefiles/${FORMAT_COMPILER_TARGET}/mednafen-wswan-libretro/Makefile" ] && cp "$rootdir/makefiles/${FORMAT_COMPILER_TARGET}/mednafen-wswan-libretro/Makefile" .

    [ -z "${NOCLEAN}" ] && make -f Makefile clean || echo "Failed to clean!"
    make -f Makefile platform="${FORMAT_COMPILER_TARGET}" ${COMPILER} 2>&1 | tee makefile.log
    [ ${PIPESTATUS[0]} -ne 0 ] && __ERRMSGS="Could not successfully compile WSWAN LibretroCore mednafen-wswan!"
    [ -f makefile.log ] && cp makefile.log $outputdir/_log.makefile.mednafenwswanlibretro

    popd
}

function configure_a_mednafenwswanlibretro() {
    mkdir -p $romdir/wswan

    #setESSystem "TurboGrafx 16 (PC Engine)" "pcengine" "~/RetroPie/roms/pcengine" ".pce .PCE" "$rootdir/supplementary/runcommand/runcommand.sh 1 \"$rootdir/emulators/RetroArch/installdir/bin/retroarch -L `find $rootdir/emulatorcores/mednafenpcefast/ -name \"*libretro*.so\" | head -1` --config $rootdir/configs/all/retroarch.cfg --appendconfig $rootdir/configs/pcengine/retroarch.cfg %ROM%\"" "pcengine" "pcengine"
}

function copy_a_mednafenwswanlibretro() {
    [ -z "$so_filter" ] && so_filter="*libretro*.so"
    find $rootdir/emulatorcores/mednafen-wswan-libretro/ -name $so_filter | xargs cp -t $outputdir
}