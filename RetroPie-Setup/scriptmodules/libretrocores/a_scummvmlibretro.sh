rp_module_id="a_scummvmlibretro"
rp_module_desc="SCUMMVM LibretroCore"
rp_module_menus="2+"

function sources_a_scummvmlibretro() {
    gitPullOrClone "$rootdir/emulatorcores/scummvm" git://github.com/libretro/scummvm.git
}

function build_a_scummvmlibretro() {
    pushd "$rootdir/emulatorcores/scummvm/backends/platform/libretro/build/"

    [ -z "${NOCLEAN}" ] && make -f Makefile clean || echo "Failed to clean!"
    make -f Makefile platform="${FORMAT_COMPILER_TARGET}" ${COMPILER} 2>&1 | tee makefile.log || echo -e "Failed to compile!"
    [ -f makefile.log ] && cp makefile.log $outputdir/_log.makefile.scummvmlibretro

    [ -z "$so_filter" ] && so_filter="*libretro*.so"
    if [[ -z `find $rootdir/emulatorcores/scummvm/backends/platform/libretro/build/ -name "$so_filter"` ]]; then
        __ERRMSGS="$__ERRMSGS Could not successfully compile SCUMMVM core."
    fi

    popd
}

function configure_a_scummvmlibretro() {
    mkdir -p $romdir/scummvm

    #rps_retronet_prepareConfig
    #setESSystem "SCUMMVM" "scummvm" "~/RetroPie/roms/scummvm" ".exe" "$rootdir/supplementary/runcommand/runcommand.sh 2 \"$rootdir/emulators/RetroArch/installdir/bin/retroarch -L `find $rootdir/emulatorcores/scummvm/ -name \"*libretro*.so\" | head -1` --config $rootdir/configs/all/retroarch.cfg --appendconfig $rootdir/configs/summvm/retroarch.cfg $__tmpnetplaymode$__tmpnetplayhostip_cfile$__tmpnetplayport$__tmpnetplayframes %ROM%\"" "scummvm" "summvm"
}

function copy_a_scummvmlibretro() {
    [ -z "$so_filter" ] && so_filter="*libretro*.so"
    find $rootdir/emulatorcores/scummvm/backends/platform/libretro/build/ -name $so_filter | xargs cp -t $outputdir
}