rp_module_id="a_stellalibretro"
rp_module_desc="Atari 2600 LibretroCore Stella (Additional)"
rp_module_menus="2+"

function sources_a_stellalibretro() {
    gitPullOrClone "$rootdir/emulatorcores/stella-libretro" git://github.com/libretro/stella-libretro.git
}

function build_a_stellalibretro() {
    pushd "$rootdir/emulatorcores/stella-libretro"

    [ -z "${NOCLEAN}" ] && make -f Makefile clean || echo "Failed to clean!"
    if [ ${FORMAT_COMPILER_TARGET} = "armv6j-hardfloat" ]; then
        #FIX
        make -f Makefile platform=unix ${COMPILER} 2>&1 | tee makefile.log
    else
        make -f Makefile platform="${FORMAT_COMPILER_TARGET}" ${COMPILER} 2>&1 | tee makefile.log
    fi
    [ ${PIPESTATUS[0]} -ne 0 ] && __ERRMSGS="Could not successfully compile Atari 2600 LibretroCore Stella!"
    [ -f makefile.log ] && cp makefile.log $outputdir/_log.makefile.stellalibretro

    popd
}

function configure_a_stellalibretro() {
    mkdir -p $romdir/atari2600-libretro

    rps_retronet_prepareConfig
    setESSystem "Atari 2600" "atari2600-libretro" "~/RetroPie/roms/atari2600-libretro" ".a26 .A26 .bin .BIN .rom .ROM .zip .ZIP .gz .GZ" "$rootdir/supplementary/runcommand/runcommand.sh 1 \"$rootdir/emulators/RetroArch/installdir/bin/retroarch -L `find $rootdir/emulatorcores/stella-libretro/ -name \"*libretro*.so\" | head -1` --config $rootdir/configs/all/retroarch.cfg --appendconfig $rootdir/configs/atari2600/retroarch.cfg $__tmpnetplaymode$__tmpnetplayhostip_cfile$__tmpnetplayport$__tmpnetplayframes %ROM%\"" "atari2600" "atari2600"
}

function copy_a_stellalibretro() {
    [ -z "$so_filter" ] && so_filter="*libretro*.so"
    find $rootdir/emulatorcores/stella-libretro/ -name $so_filter | xargs cp -t $outputdir
}