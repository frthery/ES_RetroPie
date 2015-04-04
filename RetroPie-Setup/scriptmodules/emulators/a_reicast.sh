rp_module_id="a_reicast"
rp_module_desc="DREAMCAST Reicast"
rp_module_menus="4+"

function sources_a_reicast() {
    #libasound2-dev
    #gitPullOrClone "$rootdir/emulators/reicast-emulator" git://github.com/reicast/reicast-emulator.git
	gitPullOrClone "$rootdir/emulators/reicast-emulator" https://github.com/reicast/reicast-emulator.git skmp/rapi2
    #return 0
}

function build_a_reicast() {
    #rpSwap on 750

    pushd "$rootdir/emulators/reicast-emulator/shell/rapi2"

    # Add missing path
    # sed -i 's|GL_LIB := -lGLESv2|GL_LIB := -L/opt/vc/lib -lGLESv2|g' Makefile

    [ -z "${NOCLEAN}" ] && make -f Makefile clean || echo "Failed to clean!"
    if [[ ${FORMAT_COMPILER_TARGET} =~ "armv6" ]]; then
        make platform=rpi CC="gcc-4.8" CXX="g++-4.8" 2>&1 | tee makefile.log
    elif [[ ${FORMAT_COMPILER_TARGET} =~ "armv7" ]]; then
        make platform=rpi2 CC="gcc-4.8" CXX="g++-4.8" 2>&1 | tee makefile.log
    else
        make -f Makefile platform="${FORMAT_COMPILER_TARGET}" ${COMPILER} 2>&1 | tee makefile.log
    fi    
    [ ${PIPESTATUS[0]} -ne 0 ] && __ERRMSGS="Could not successfully compile N64 LibretroCore Mupen64Plus!"
    [ -f makefile.log ] && cp makefile.log $outputdir/_log.makefile.reicast

    popd

    #rpSwap off
}

function configure_a_reicast() {
    return 0
}

