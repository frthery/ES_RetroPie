rp_module_id="a_pcsx_rearmed"
rp_module_desc="Playstation 1 pcsx_rearmed (Additional)"
rp_module_menus="2+"

function depends_a_pcsx_rearmed() {
    getDepends libpng-dev libsdl1.2-dev
}

function sources_a_pcsx_rearmed() {
    gitPullOrClone "$rootdir/emulators/pcsx_rearmed" git://github.com/notaz/pcsx_rearmed.git

    pushd "$rootdir/emulators/pcsx_rearmed"
    git submodule init && git submodule update
    popd
}

function build_a_pcsx_rearmed() {
    pushd "$rootdir/emulators/pcsx_rearmed"

    git submodule init && git submodule update
    ./configure --sound-drivers=sdl
    #make clean
    make

    popd
}

function configure_a_pcsx_rearmed() {
    mkdir -p $romdir/psx

    #rps_retronet_prepareConfig
    #sample: ./pcsx -cdfile /home/pi/RidgeRacer/ridgeracer.cue
    #setESSystem "Sony Playstation 1" "psx" "~/RetroPie/roms/psx" ".img .IMG .bin .BIN .cue .CUE" "$rootdir/supplementary/runcommand/runcommand.sh 1 \"$rootdir/emulators/pcsx_rearmed/pcsx -cdfile %ROM%\"" "psx" "psx"
}
