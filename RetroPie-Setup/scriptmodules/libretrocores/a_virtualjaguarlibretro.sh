rp_module_id="a_virtualjaguarlibretro"
rp_module_desc="JAGUAR LibretroCore VirtualJaguar"
rp_module_menus="2+"

function sources_a_virtualjaguarlibretro() {
    gitPullOrClone "$rootdir/emulatorcores/virtualjaguar-libretro" git://github.com/libretro/virtualjaguar-libretro.git
}

function build_a_virtualjaguarlibretro() {
    pushd "$rootdir/emulatorcores/virtualjaguar-libretro"

    [ -z "${NOCLEAN}" ] && make -f Makefile clean || echo "Failed to clean!"
    make -f Makefile platform=unix ${COMPILER} 2>&1 | tee makefile.log || echo -e "Failed to compile!"
    [ -f makefile.log ] && cp makefile.log $outputdir/_log.makefile.virtualjaguarlibretro

    [ -z "$so_filter" ] && so_filter="*libretro*.so"
    if [[ -z `find $rootdir/emulatorcores/virtualjaguar-libretro/ -name "$so_filter"` ]]; then
        __ERRMSGS="$__ERRMSGS Could not successfully compile VIRTUALJAGUAR core."
    fi
    
    popd
}

function configure_a_virtualjaguarlibretro() {
    mkdir -p $romdir/jaguar

    #rps_retronet_prepareConfig
    #setESSystem "Virtual Jaguar" "virtualjaguar" "~/RetroPie/roms/jaguar" ".img .IMG .7z .7Z .pbp .PBP .bin .BIN .cue .CUE" "$rootdir/supplementary/runcommand/runcommand.sh 2 \"$rootdir/emulators/RetroArch/installdir/bin/retroarch -L `find $rootdir/emulatorcores/virtualjaguar-libretro/ -name \"*libretro*.so\" | head -1` --config $rootdir/configs/all/retroarch.cfg --appendconfig $rootdir/configs/virtualjaguar/retroarch.cfg $__tmpnetplaymode$__tmpnetplayhostip_cfile$__tmpnetplayport$__tmpnetplayframes %ROM%\"" "virtualjaguar" "virtualjaguar"
}

function copy_a_virtualjaguarlibretro() {
    [ -z "$so_filter" ] && so_filter="*libretro*.so"
    find $rootdir/emulatorcores/virtualjaguar-libretro/ -name $so_filter | xargs cp -t $outputdir
}