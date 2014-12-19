rp_module_id="vbanextlibretro"
rp_module_desc="GBA LibretroCore VbaNext"
rp_module_menus="2+"

function sources_vbanextlibretro() {
    gitPullOrClone "$rootdir/emulatorcores/vba-next" git://github.com/libretro/vba-next
}

function build_vbanextlibretro() {
    pushd "$rootdir/emulatorcores/vba-next/"

    [ -z "${NOCLEAN}" ] && make -f Makefile.libretro clean || echo "Failed to clean!"
    make -f Makefile.libretro platform="${FORMAT_COMPILER_TARGET}" ${COMPILER} 2>&1 | tee makefile.log || echo -e "Failed to compile!"
    [ -f makefile.log ] && cp makefile.log $outputdir/_log.makefile.vbanextlibretro

    [ -z "$so_filter" ] && so_filter="*libretro*.so"
    if [[ -z `find $rootdir/emulatorcores/vba-next/ -name "$so_filter"` ]]; then
        __ERRMSGS="$__ERRMSGS Could not successfully compile VBANEXT core."
    fi

    popd
}

function configure_vbanextlibretro() {
    mkdir -p $romdir/gba

    #rps_retronet_prepareConfig
    #setESSystem "Gameboy Advance" "gba" "~/RetroPie/roms/gba" ".gba .GBA" "$rootdir/supplementary/runcommand/runcommand.sh 2 \"$rootdir/emulators/RetroArch/installdir/bin/retroarch -L `find $rootdir/emulatorcores/vbanext/ -name \"*libretro*.so\" | head -1` --config $rootdir/configs/all/retroarch.cfg --appendconfig $rootdir/configs/vbanext/retroarch.cfg $__tmpnetplaymode$__tmpnetplayhostip_cfile$__tmpnetplayport$__tmpnetplayframes %ROM%\"" "gba" "gba"
}

function copy_vbanextlibretro() {
    [ -z "$so_filter" ] && so_filter="*libretro*.so"
    find $rootdir/emulatorcores/vba-next/ -name $so_filter | xargs cp -t $outputdir
}