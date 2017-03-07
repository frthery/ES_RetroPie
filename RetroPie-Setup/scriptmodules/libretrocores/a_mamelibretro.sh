rp_module_id="a_mamelibretro"
rp_module_desc="MAME LibretroCore (Additional)"
rp_module_menus="2+"

function sources_a_mamelibretro() {
    gitPullOrClone "$rootdir/emulatorcores/mame-libretro" git://github.com/libretro/mame.git
}

function build_a_mamelibretro() {
    pushd "$rootdir/emulatorcores/mame-libretro"

    ln -s /usr/x86_64-w64-mingw32 /mingw64

    [ -z "${NOCLEAN}" ] && make -f Makefile.libretro clean
    if [[ ${FORMAT_COMPILER_TARGET} = "win" ]]; then
        make -f Makefile.libretro platform="${FORMAT_COMPILER_TARGET}" MSYSTEM=MINGW64 ${COMPILER} 2>&1 | tee makefile.log
    else
        #make TARGET=mess
        make -f Makefile.libretro platform="${FORMAT_COMPILER_TARGET}" ${COMPILER} 2>&1 | tee makefile.log
    fi
    [ ${PIPESTATUS[0]} -ne 0 ] && __ERRMSGS="Could not successfully compile MAME LibretroCore!"
    [ -f makefile.log ] && cp makefile.log $outputdir/_log.makefile.mamelibretro

    unlink /mingw64

    popd
}

function copy_a_mamelibretro() {
    [ -z "$so_filter" ] && so_filter="*libretro*.so"
    find $rootdir/emulatorcores/mame-libretro/ -name $so_filter | xargs cp -t $outputdir
}