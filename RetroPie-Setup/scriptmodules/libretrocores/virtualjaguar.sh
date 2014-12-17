rp_module_id="virtualjaguar"
rp_module_desc="JAGUAR LibretroCore virtualjaguar"
rp_module_menus="2+"

function sources_virtualjaguar() {
    gitPullOrClone "$rootdir/emulatorcores/virtualjaguar" https://github.com/libretro/virtualjaguar-libretro.git
}

function build_virtualjaguar() {
    pushd "$rootdir/emulatorcores/virtualjaguar"

    [ -z "${NOCLEAN}" ] && make -f Makefile clean || echo "Failed to clean [code=$?] !"
    make -f Makefile platform="${FORMAT_COMPILER_TARGET}" ${COMPILER} || echo "Failed to build [code=$?] !"

    [ -z "$so_filter" ] && so_filter="*libretro*.so"
    if [[ -z `find $rootdir/emulatorcores/virtualjaguar/ -name "$so_filter"` ]]; then
        __ERRMSGS="$__ERRMSGS Could not successfully compile YABAUSE core."
    fi
    
    popd
}

function configure_virtualjaguar() {
    mkdir -p $romdir/jaguar

    #rps_retronet_prepareConfig
    #setESSystem "Virtual Jaguar" "virtualjaguar" "~/RetroPie/roms/virtualjaguar" ".img .IMG .7z .7Z .pbp .PBP .bin .BIN .cue .CUE" "$rootdir/supplementary/runcommand/runcommand.sh 2 \"$rootdir/emulators/RetroArch/installdir/bin/retroarch -L `find $rootdir/emulatorcores/virtualjaguar/ -name \"*libretro*.so\" | head -1` --config $rootdir/configs/all/retroarch.cfg --appendconfig $rootdir/configs/virtualjaguar/retroarch.cfg $__tmpnetplaymode$__tmpnetplayhostip_cfile$__tmpnetplayport$__tmpnetplayframes %ROM%\"" "virtualjaguar" "virtualjaguar"
}

function copy_virtualjaguar() {
    [ -z "$so_filter" ] && so_filter="*libretro*.so"
    find $rootdir/emulatorcores/virtualjaguar/ -name $so_filter | xargs cp -t ./bin
}