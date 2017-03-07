rp_module_id="a_mupen64libretro"
rp_module_desc="N64 LibretroCore Mupen64Plus (Additional)"
rp_module_menus="4+"

function sources_a_mupen64libretro() {
    #rmDirExists "$rootdir/emulatorcores/mupen64plus"
    
    # Base repo:
    #[ ${FORMAT_COMPILER_TARGET} = "win" ] && gitPullOrClone "$rootdir/emulatorcores/mupen64plus" git://github.com/libretro/mupen64plus-libretro.git
    # Freezed fixed repo:
    #[[ ${FORMAT_COMPILER_TARGET} =~ "armv" ]] && gitPullOrClone "$rootdir/emulatorcores/mupen64plus" git://github.com/gizmo98/mupen64plus-libretro.git
    
    #gitPullOrClone "$rootdir/emulatorcores/mupen64plus" git://github.com/libretro/mupen64plus-libretro.git
    #gitPullOrClone "$rootdir/emulatorcores/mupen64plus" git://github.com/gizmo98/mupen64plus-libretro.git
    gitPullOrClone "$rootdir/emulatorcores/mupen64plus" https://github.com/libretro/mupen64plus-libretro.git
}

function build_a_mupen64libretro() {
    #rpSwap on 750

    pushd "$rootdir/emulatorcores/mupen64plus"

    # Add missing path --> Fix already merged https://github.com/libretro/mupen64plus-libretro/commit/c035cf1c7a2514aeb14adf51ad825208ff1a068d
    # sed -i 's|GL_LIB := -lGLESv2|GL_LIB := -L/opt/vc/lib -lGLESv2|g' Makefile

    [ -z "${NOCLEAN}" ] && make -f Makefile clean
    if [[ ${FORMAT_COMPILER_TARGET} =~ "armv6" ]]; then
        make platform=rpi ${COMPILER} 2>&1 | tee makefile.log
    elif [[ ${FORMAT_COMPILER_TARGET} =~ "armv7" ]]; then
        make platform=rpi2 ${COMPILER} 2>&1 | tee makefile.log
    else
        make -f Makefile platform="${FORMAT_COMPILER_TARGET}" ${COMPILER} 2>&1 | tee makefile.log
    fi
    
    [ ${PIPESTATUS[0]} -ne 0 ] && __ERRMSGS="Could not successfully compile N64 LibretroCore Mupen64Plus!"
    [ -f makefile.log ] && cp makefile.log $outputdir/_log.makefile.mupen64libretro

    popd

    #rpSwap off
}

function copy_a_mupen64libretro() {
    [ -z "$so_filter" ] && so_filter="*libretro*.so"
    find $rootdir/emulatorcores/mupen64plus/ -name $so_filter | xargs cp -t $outputdir
}
