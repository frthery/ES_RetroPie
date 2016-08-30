rp_module_id="a_glupen64libretro"
rp_module_desc="N64 LibretroCore Glupen64Plus (Additional)"
rp_module_menus="4+"

function sources_a_glupen64libretro() {
    gitPullOrClone "$rootdir/emulatorcores/glupen64-libretro" git://github.com/loganmc10/GLupeN64.git
	git submodule update --init
	#git submodule init && git submodule update
}

function build_a_glupen64libretro() {
    #rpSwap on 750

    pushd "$rootdir/emulatorcores/glupen64-libretro"

    [ -z "${NOCLEAN}" ] && make -f Makefile clean
    #make platform=rpi ${COMPILER} 2>&1 | tee makefile.log
    make -f Makefile platform="${FORMAT_COMPILER_TARGET}" ${COMPILER} 2>&1 | tee makefile.log
    
    [ ${PIPESTATUS[0]} -ne 0 ] && __ERRMSGS="Could not successfully compile N64 LibretroCore Glupen64Plus!"
    [ -f makefile.log ] && cp makefile.log $outputdir/_log.makefile.glupen64libretro

    popd

    #rpSwap off
}

function configure_a_glupen64libretro() {
    mkdir -p $romdir/n64
}

function copy_a_glupen64libretro() {
    [ -z "$so_filter" ] && so_filter="*libretro*.so"
    find $rootdir/emulatorcores/glupen64-libretro/ -name $so_filter | xargs cp -t $outputdir
}
