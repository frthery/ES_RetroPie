rp_module_id="a_uae4all2"
rp_module_desc="AMIGA emulator a_uae4all2 (Additional)"
rp_module_menus="2+"

function depends_a_uae4all2() {
    rps_checkNeededPackages libsdl1.2-dev libsdl-mixer1.2-dev libasound2-dev
}

function sources_a_uae4all2() {
    #kick.rom: http://misapuntesde.com/res/Amiga_roms.zip
    #ftp://researchlab.spdns.de/rpi/uae4all2/uae4all2-2.3.5.3rpi.tgz

    rmDirExists "$rootdir/emulators/uae4all2"
    [ ! -d tmp ] && mkdir tmp
    [ -f tmp/uae4all-2.5.3.2-1rpi.tgz ] && rm tmp/uae4all-2.5.3.2-1rpi.tgz
    wget ftp://researchlab.spdns.de/rpi/uae4all/uae4all-2.5.3.2-1rpi.tgz -P tmp
    tar zxvf tmp/uae4all-2.5.3.2-1rpi.tgz -C "tmp" && rm tmp/uae4all-2.5.3.2-1rpi.tgz
    mv "tmp/uae4all" "$rootdir/emulators/uae4all2"
    #popd
}

function configure_a_uae4all2() {
    mkdir -p $romdir/amiga

    #startAmigaDisk.sh
    wget https://raw.githubusercontent.com/frthery/ES_RetroPie/master/RetroPie-Setup/supplementary/startAmigaDisk.sh -P tmp
    mv tmp/startAmigaDisk.sh "$rootdir/emulators/uae4all2/"

    chmod 755 "$rootdir/emulators/uae4all2/startAmigaDisk.sh"
    chown -R pi:pi "$rootdir/emulators/uae4all2"

    #rps_retronet_prepareConfig
    #setESSystem "Amiga" "amiga" "~/RetroPie/roms/amiga" ".adf .ADF" "$rootdir/emulators/uae4all_rc3_05/startAmigaDisk.sh %ROM%" "amiga" "amiga"
}
