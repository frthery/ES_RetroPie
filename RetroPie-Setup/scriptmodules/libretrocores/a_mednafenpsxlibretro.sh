rp_module_id="a_mednafenpsxlibretro"
rp_module_desc="PSX LibretroCore mednafen-psx-libretro (Additional)"
rp_module_menus="2+"

function sources_a_mednafenpsxlibretro() {
    gitPullOrClone "$rootdir/emulatorcores/mednafen-psx-libretro" git://github.com/libretro/mednafen-psx-libretro
}

function build_a_mednafenpsxlibretro() {
    pushd "$rootdir/emulatorcores/mednafen-psx-libretro"

    # OVERRIDE MAKEFILE IF NECESSARY
    [ -f "$rootdir/makefiles/${FORMAT_COMPILER_TARGET}/mednafen-psx-libretro/Makefile" ] && cp "$rootdir/makefiles/${FORMAT_COMPILER_TARGET}/mednafen-psx-libretro/Makefile" .

    [ -z "${NOCLEAN}" ] && make -f Makefile clean || echo "Failed to clean!"
    make -f Makefile platform="${FORMAT_COMPILER_TARGET}" ${COMPILER} 2>&1 | tee makefile.log
    [ ${PIPESTATUS[0]} -ne 0 ] && __ERRMSGS="Could not successfully compile PSX LibretroCore mednafen-psx-libretro!"
    [ -f makefile.log ] && cp makefile.log $outputdir/_log.makefile.mednafenpsxlibretro

    popd
}

function configure_a_mednafenpsxlibretro() {
    mkdir -p $romdir/psx

    #rps_retronet_prepareConfig
    #setESSystem "Sony Playstation 1" "psx" "~/RetroPie/roms/psx" ".img .IMG .7z .7Z .pbp .PBP .bin .BIN .cue .CUE" "$rootdir/supplementary/runcommand/runcommand.sh 1 \"$rootdir/emulators/RetroArch/installdir/bin/retroarch -L `find $rootdir/emulatorcores/pcsx_rearmed/ -name \"*libretro*.so\" | head -1` --config $rootdir/configs/all/retroarch.cfg --appendconfig $rootdir/configs/psx/retroarch.cfg %ROM%\"" "psx" "psx"
}

function copy_a_mednafenpsxlibretro() {
    [ -z "$so_filter" ] && so_filter="*libretro*.so"
    find $rootdir/emulatorcores/mednafen-psx-libretro/ -name $so_filter | xargs cp -t $outputdir
}