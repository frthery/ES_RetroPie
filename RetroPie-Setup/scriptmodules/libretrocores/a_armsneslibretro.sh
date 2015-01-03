rp_module_id="a_armsneslibretro"
rp_module_desc="SNES LibretroCore armsnes (Additional)"
rp_module_menus="4+"

function sources_a_armsneslibretro() {
    gitPullOrClone "$rootdir/emulatorcores/armsnes-libretro" git://github.com/rmaz/ARMSNES-libretro
    
    pushd "$rootdir/emulatorcores/armsnes-libretro"
    patch -N -i $scriptdir/supplementary/pocketsnesmultip.patch $rootdir/emulatorcores/armsnes-libretro/src/ppu.cpp
    popd
}

function build_a_armsneslibretro() {
    pushd "$rootdir/emulatorcores/armsnes-libretro"

    [ -z "${NOCLEAN}" ] && make -f Makefile clean || echo "Failed to clean!"
    make -f Makefile platform="${FORMAT_COMPILER_TARGET}" ${COMPILER} 2>&1 | tee makefile.log
    [ ${PIPESTATUS[0]} -ne 0 ] && __ERRMSGS="Could not successfully compile SNES LibretroCore armsnes!"
    [ -f makefile.log ] && cp makefile.log $outputdir/_log.makefile.armsneslibretro

    popd
}

function configure_a_armsneslibretro() {
    mkdir -p $romdir/snes

    rps_retronet_prepareConfig
    setESSystem "Super Nintendo" "snes" "~/RetroPie/roms/snes" ".smc .sfc .fig .swc .SMC .SFC .FIG .SWC" "$rootdir/supplementary/runcommand/runcommand.sh 4 \"$rootdir/emulators/RetroArch/installdir/bin/retroarch -L `find $rootdir/emulatorcores/armsnes-libretro/ -name \"libpocketsnes.so\" | head -1` --config $rootdir/configs/all/retroarch.cfg --appendconfig $rootdir/configs/snes/retroarch.cfg $__tmpnetplaymode$__tmpnetplayhostip_cfile $__tmpnetplayport$__tmpnetplayframes %ROM%\"" "snes" "snes"
    # <!-- alternatively: <command>$rootdir/emulators/snes9x-rpi/snes9x %ROM%</command> -->
    # <!-- alternatively: <command>$rootdir/emulators/pisnes/snes9x %ROM%</command> -->
}

function copy_a_armsneslibretro() {
    [ -z "$so_filter" ] && so_filter="*libretro*.so"
    outfile=$outputdir/armsnes_$(echo $so_filter | sed 's/*//g')
    file=$(find $rootdir/emulatorcores/armsnes-libretro/ -name libpocketsnes.*) && cp $file $outfile
}
