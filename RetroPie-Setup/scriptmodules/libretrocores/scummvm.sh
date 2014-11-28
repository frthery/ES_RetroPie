rp_module_id="scummvm"
rp_module_desc="SCUMMVM LibretroCore"
rp_module_menus="2+"

function sources_scummvm() {
    gitPullOrClone "$rootdir/emulatorcores/scummvm" git://github.com/libretro/scummvm
}

function build_scummvm() {
    pushd "$rootdir/emulatorcores/scummvm/backends/platform/libretro/build/"
	make clean
	make 
    popd
    if [[ -z `find $rootdir/emulatorcores/scummvm/backends/platform/libretro/build/ -name "*libretro*.so"` ]]; then
        __ERRMSGS="$__ERRMSGS Could not successfully compile SCUMMVM core."
    fi
}

function configure_scummvm() {
    mkdir -p $romdir/scummvm

    #rps_retronet_prepareConfig
    #setESSystem "SCUMMVM" "scummvm" "~/RetroPie/roms/scummvm" ".exe" "$rootdir/supplementary/runcommand/runcommand.sh 2 \"$rootdir/emulators/RetroArch/installdir/bin/retroarch -L `find $rootdir/emulatorcores/scummvm/ -name \"*libretro*.so\" | head -1` --config $rootdir/configs/all/retroarch.cfg --appendconfig $rootdir/configs/summvm/retroarch.cfg $__tmpnetplaymode$__tmpnetplayhostip_cfile$__tmpnetplayport$__tmpnetplayframes %ROM%\"" "scummvm" "summvm"
}