rp_module_id="pcsx_rearmed"
rp_module_desc="Playstation 1 LibretroCore pcsx_rearmed"
rp_module_menus="2+"

function sources_pcsx_rearmed() {
    gitPullOrClone "$rootdir/emulatorcores/pcsx_rearmed" git://github.com/libretro/pcsx_rearmed.git
}

function build_pcsx_rearmed() {
    pushd "$rootdir/emulatorcores/pcsx_rearmed"

    ./configure --platform=libretro
    make clean || echo "Failed to clean [code=$?] !"
    make -f Makefile.libretro ${COMPILER} USE_DYNAREC=1 BUILTIN_GPU=neon || echo "Failed to build [code=$?] !"

    if [[ -z `find $rootdir/emulatorcores/pcsx_rearmed/ -name "*libretro*.so"` ]]; then
        __ERRMSGS="$__ERRMSGS Could not successfully compile Playstation core."
    fi

    popd
}

function configure_pcsx_rearmed() {
    mkdir -p $romdir/psx

    #rps_retronet_prepareConfig
    #setESSystem "Sony Playstation 1" "psx" "~/RetroPie/roms/psx" ".img .IMG .7z .7Z .pbp .PBP .bin .BIN .cue .CUE" "$rootdir/supplementary/runcommand/runcommand.sh 1 \"$rootdir/emulators/RetroArch/installdir/bin/retroarch -L `find $rootdir/emulatorcores/pcsx_rearmed/ -name \"*libretro*.so\" | head -1` --config $rootdir/configs/all/retroarch.cfg --appendconfig $rootdir/configs/psx/retroarch.cfg %ROM%\"" "psx" "psx"
}

function copy_pcsx_rearmed() {
    [ -z "$so_filter" ] && so_filter="*libretro*.so"
    find $rootdir/emulatorcores/pcsx_rearmed/ -name $so_filter | xargs cp -t ./bin
}