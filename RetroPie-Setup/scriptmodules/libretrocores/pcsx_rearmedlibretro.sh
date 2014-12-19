rp_module_id="pcsx_rearmedlibretro"
rp_module_desc="Playstation 1 LibretroCore pcsx_rearmed"
rp_module_menus="2+"

function sources_pcsx_rearmedlibretro() {
    gitPullOrClone "$rootdir/emulatorcores/pcsx_rearmed" git://github.com/libretro/pcsx_rearmed.git
}

function build_pcsx_rearmedlibretro() {
    pushd "$rootdir/emulatorcores/pcsx_rearmed"

    ./configure --platform=libretro
    make clean || echo "Failed to clean!"
    make -f Makefile.libretro ${COMPILER} USE_DYNAREC=1 BUILTIN_GPU=neon 2>&1 | tee makefile.log || echo -e "Failed to compile!"
    [ -f makefile.log ] && cp makefile.log $outputdir/_log.makefile.pcsx_rearmedlibretro

    if [[ -z `find $rootdir/emulatorcores/pcsx_rearmed/ -name "*libretro*.so"` ]]; then
        __ERRMSGS="$__ERRMSGS Could not successfully compile Playstation core."
    fi

    popd
}

function configure_pcsx_rearmedlibretro() {
    mkdir -p $romdir/psx

    #rps_retronet_prepareConfig
    #setESSystem "Sony Playstation 1" "psx" "~/RetroPie/roms/psx" ".img .IMG .7z .7Z .pbp .PBP .bin .BIN .cue .CUE" "$rootdir/supplementary/runcommand/runcommand.sh 1 \"$rootdir/emulators/RetroArch/installdir/bin/retroarch -L `find $rootdir/emulatorcores/pcsx_rearmed/ -name \"*libretro*.so\" | head -1` --config $rootdir/configs/all/retroarch.cfg --appendconfig $rootdir/configs/psx/retroarch.cfg %ROM%\"" "psx" "psx"
}

function copy_pcsx_rearmedlibretro() {
    [ -z "$so_filter" ] && so_filter="*libretro*.so"
    find $rootdir/emulatorcores/pcsx_rearmed/ -name $so_filter | xargs cp -t $outputdir
}