rp_module_id="a_vbanextlibretro"
rp_module_desc="GBA LibretroCore VbaNext (Additional)"
rp_module_menus="2+"

function sources_a_vbanextlibretro() {
    gitPullOrClone "$rootdir/emulatorcores/vba-next" git://github.com/libretro/vba-next
}

function build_a_vbanextlibretro() {
    pushd "$rootdir/emulatorcores/vba-next/"

    [ -z "${NOCLEAN}" ] && make -f Makefile.libretro clean
    make -f Makefile.libretro platform="${FORMAT_COMPILER_TARGET}" ${COMPILER} 2>&1 | tee makefile.log
    [ ${PIPESTATUS[0]} -ne 0 ] && __ERRMSGS="Could not successfully compile GBA LibretroCore VbaNext!"
    [ -f makefile.log ] && cp makefile.log $outputdir/_log.makefile.vbanextlibretro

    popd
}

function configure_a_vbanextlibretro() {
    mkdir -p $romdir/gba

    #rps_retronet_prepareConfig
    #setESSystem "Gameboy Advance" "gba" "~/RetroPie/roms/gba" ".gba .GBA" "$rootdir/supplementary/runcommand/runcommand.sh 2 \"$rootdir/emulators/RetroArch/installdir/bin/retroarch -L `find $rootdir/emulatorcores/vbanext/ -name \"*libretro*.so\" | head -1` --config $rootdir/configs/all/retroarch.cfg --appendconfig $rootdir/configs/vbanext/retroarch.cfg $__tmpnetplaymode$__tmpnetplayhostip_cfile$__tmpnetplayport$__tmpnetplayframes %ROM%\"" "gba" "gba"
}

function copy_a_vbanextlibretro() {
    [ -z "$so_filter" ] && so_filter="*libretro*.so"
    find $rootdir/emulatorcores/vba-next/ -name $so_filter | xargs cp -t $outputdir
}