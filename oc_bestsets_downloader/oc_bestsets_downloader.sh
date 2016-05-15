#!/bin/bash

# CONFIGURE YOUR ROMS PATH
ROMS_PATH='/home/pi/RetroPie/roms'

# FUNCTIONS
function check_install_unrar() {
    [ -f /usr/bin/unrar-nonfree ] && echo [CHECK]: unrar-nonfree OK! && return 0

    cat /etc/apt/sources.list | grep "deb-src http://mirrordirector.raspbian.org/raspbian/ wheezy main contrib non-free rpi"
    [ $? -eq 1 ] && echo "deb-src http://mirrordirector.raspbian.org/raspbian/ wheezy main contrib non-free rpi" | sudo tee --append /etc/apt/sources.list
    sudo apt-get update

    pushd ${OC_TMP_PATH}
    sudo apt-get --assume-yes build-dep unrar-nonfree
    sudo apt-get --assume-yes source -b unrar-nonfree
    sudo dpkg -i unrar_*_armhf.deb
    popd

    [ -f /usr/bin/unrar-nonfree ] && echo [CHECK]: unrar-nonfree OK! && return 0
    [ ! -f /usr/bin/unrar-nonfree ] && echo [CHECK]: unrar-nonfree KO! && return 1
}

function check_install_megatools() {
    [ -f /usr/local/bin/megadl ] && echo [CHECK]: megatools OK! && return 0

    #megatools: http://megatools.megous.com/
    sudo apt-get --assume-yes install gcc build-essential libcurl4-openssl-dev libglib2.0-dev glib-networking
    wget http://megatools.megous.com/builds/megatools-1.9.94.tar.gz -P ${OC_TMP_PATH}
    tar -xvzf ${OC_TMP_PATH}/megatools-1.9.94.tar.gz -C ${OC_TMP_PATH}
    pushd ${OC_TMP_PATH}/megatools-1.9.94
    ./configure --disable-shared
    make
    sudo make install
    popd

    [ -f /usr/local/bin/megadl ] && echo [CHECK]: megatools OK! && return 0
    [ ! -f /usr/local/bin/megadl ] && echo [CHECK]: megatools KO! && return 1
}

function initialize() {
    local clearRoms=$1

    [ $OPT_LOCAL -eq 0 ] && [ -f ${OC_FILE_INI} ] && mv ${OC_FILE_INI} ${OC_FILE_INI}.old
    [ $OPT_LOCAL -eq 0 ] && [ $OPT_MEGA -eq 1 ] && echo '[GET|MEGA.INI]: '${OC_MEGA_FILE_INI} && wget --no-check-certificate ${OC_MEGA_FILE_INI} -O ${OC_FILE_INI} 2> /dev/null
    [ $OPT_LOCAL -eq 0 ] && [ $OPT_DRIVE -eq 1 ] && echo '[GET|DRIVE.INI]: '${OC_DRIVE_FILE_INI} && wget --no-check-certificate ${OC_DRIVE_FILE_INI} -O ${OC_FILE_INI} 2> /dev/null
    [ ! -f ${OC_FILE_INI} ] && echo '[ERROR]: no ini file ['${OC_FILE_INI}'] found!' && return 1

    [ $OPT_NOINSTALL -eq 1 ] && return 0

    [ ! -d ${OC_PATH} ] && mkdir ${OC_PATH} && echo '[INIT]: create folder '${OC_PATH}

    # CLEAN
    [ -d ${OC_DWL_PATH} ] && rm -R ${OC_DWL_PATH} && echo '[CLEAN]: remove folder '${OC_DWL_PATH}
    [ $clearRoms == 1 ] && [ -d ${ROMS_PATH} ] && rm -R ${ROMS_PATH} && echo '[CLEAN]: remove folder '${ROMS_PATH}

    # CREATE FOLDERS
    mkdir ${OC_DWL_PATH} && echo '[INIT]: create folder '${OC_DWL_PATH}
    [ ! -d ${ROMS_PATH} ] && mkdir ${ROMS_PATH} && echo '[INIT]: create folder '${ROMS_PATH}

    # UPDATE SYNC FILE
    touch $OC_FILE_SYNC

    # CHECK INSTALL MEGATOOLS, UNRAR-NONFREE
    if [ $OPT_MEGA -eq 1 ]; then
        [ -d ${OC_TMP_PATH} ] && sudo rm -R ${OC_TMP_PATH} && echo '[CLEAN]: remove folder '${OC_TMP_PATH}
        mkdir ${OC_TMP_PATH} && echo '[INIT]: create folder '${OC_TMP_PATH}
        
        check_install_unrar || return 1;
        check_install_megatools || return 1;
    fi

    return 0
}

function download_install() {
    local seq=0
    local idx=0

    # USE SPECIFIC SEQUENCE
    [ $OPT_SEQ ] && deploy_seq=($(echo ${OPT_SEQ} | sed 's/,/\n/g'))

    while [ $seq -lt ${#deploy_seq[@]} ]; do
        idx=${deploy_seq[$seq]}
        if [ "${packs[$idx]}" == "" ];then
            echo '[WARNING]: pack ['$idx'] not found, check deploy_seq into .ini file!'
           ((seq++))
           continue
        fi

        local infos=($(echo ${packs[$idx]} | sed 's/,/\n/g'))
        local files=($(echo ${pack_names[$idx]} | sed 's/,/\n/g'))
        #echo [FOUND: ${infos[0]}]: ${pack_names[$idx]}... && echo ${pack_links[$idx]}

        if [ "${infos[0]}" == "" ] || [ "${infos[1]}" == "" ];then
            echo '[WARNING]: infos ['$idx'] not found, check deploy_seq into .ini file!'
           ((seq++))
           continue
        fi

        # CHECK SYNCHRO
        if [ $OPT_FORCE -eq 0 ]; then
            cat ${OC_FILE_SYNC} | grep "DOWNLOAD|UNZIP: ${infos[0]}" > /dev/null
            SYNC=$?
            [ $SYNC -eq 0 ] && echo [IS_SYNC: ${infos[0]}]: ${pack_names[$idx]} && ((seq++))
            [ $SYNC -eq 0 ] && continue
        fi

        # DOWNLOAD BESTSET
        echo [DOWNLOAD: ${infos[0]}]: ${pack_names[$idx]}... && echo ${pack_links[$idx]}
        echo '-------------------------------------------------------------------------'
        if [ $OPT_MEGA -eq 1 ]; then
            megadl ${pack_links[$idx]} --path ${OC_DWL_PATH} 2> /dev/null
            DDL=$?
        elif [ $OPT_DRIVE -eq 1 ]; then
            wget --no-check-certificate ${pack_links[$idx]} -O ${OC_DWL_PATH}/${files[0]}
            DDL=$?
        fi
        echo '-------------------------------------------------------------------------'
        [ $DDL -ne 0 ] && echo '[ERROR|DOWNLOAD: '${infos[0]}']: '${pack_names[$idx]} && ((seq++)) 
        [ $DDL -ne 0 ] && continue

        if [ $OPT_FORCE -eq 1 ]; then
            [ -d ${ROMS_PATH}/${infos[1]} ] && rm -R ${ROMS_PATH}/${infos[1]} && echo '[INIT]: clean folder '${ROMS_PATH}/${infos[1]}
        fi

        # CREATE OUTPUT FOLDER
        [ ! -d ${ROMS_PATH}/${infos[1]} ] && mkdir ${ROMS_PATH}/${infos[1]} && echo '[INIT]: create folder '${ROMS_PATH}/${infos[1]}

        # UNRAR BESTSET
        echo [UNZIP]: ${files[0]} to ${ROMS_PATH}/${infos[1]}...
        echo '-------------------------------------------------------------------------'
        if [ $(echo $files[0] | grep '.rar') ]; then
            unrar-nonfree e -o+ ${OC_DWL_PATH}/${files[0]} ${ROMS_PATH}/${infos[1]}
            UNZIP=$?
        elif [ $(echo $files[0] | grep '.zip') ]; then
            unzip -o ${OC_DWL_PATH}/${files[0]} -d ${ROMS_PATH}/${infos[1]}
            UNZIP=$?
        fi
        echo '-------------------------------------------------------------------------'
        [ $UNZIP -ne 0 ] && echo '[ERROR|UNZIP] package '${infos[0]} && ((seq++)) 
        [ $UNZIP -ne 0 ] && continue

        now=`date +%Y%m%d`
        echo '[DOWNLOAD|UNZIP: '${infos[0]}']: '${pack_names[$idx]}': OK'
        echo '['$now'] [DOWNLOAD|UNZIP: '${infos[0]}']: '${pack_names[$idx]}': OK' >> ${OC_FILE_SYNC}

        ((seq++))
    done
}

function usage() {
    echo "oc_bestsets_downloader.sh [--mega-dl|--drive-dl] [--show-packages] [--prompt-deploy] [--deploy-seq] [--force-sync] [--local-ini]"
    echo ""
    echo "Show available packages: oc_bestsets_downloader.sh --show-packages"
    echo "Deploy specific packages: oc_bestsets_downloader.sh --deploy-seq=0,1,..."
    echo "use --force-sync argument to force local packages synchronization"
    echo "use --local-ini argument to force using your local ini file (oc_bestsets.ini)"
}
# END FUNCTIONS

# GLOBAL VARIABLES
OC_DRIVE_FILE_INI='https://raw.githubusercontent.com/frthery/ES_RetroPie/master/oc_bestsets_downloader/oc_bestsets.drive.ini'
OC_MEGA_FILE_INI='https://raw.githubusercontent.com/frthery/ES_RetroPie/master/oc_bestsets_downloader/oc_bestsets.mega.ini'
OC_FILE_INI='oc_bestsets.ini'
OC_FILE_SYNC=${ROMS_PATH}'/oc_bestsets_sync'
OC_PATH='./oc_bestsets_downloader'
OC_TMP_PATH=${OC_PATH}'/tmp'
OC_DWL_PATH=${OC_PATH}'/dwl'
# END GLOBAL VARIABLES

# MAIN
OPT_MEGA=0
OPT_DRIVE=1
OPT_SHOW=0
OPT_FORCE=0
OPT_LOCAL=0
OPT_NOINSTALL=0
OPT_PROMPT=0

while [ "$1" != "" ]; do
    PARAM=`echo $1 | awk -F= '{print $1}'`
    VALUE=`echo $1 | awk -F= '{print $2}'`
    case $PARAM in
        -h | --help)
            usage
            exit
            ;;
        --mega-dl)
            OPT_MEGA=1
            OPT_DRIVE=0
            ;;
        --drive-dl)
            OPT_DRIVE=1
            OPT_MEGA=0
            ;;
        --show-packages)
            # SHOW AVAILABLE PACKAGES
            OPT_SHOW=1
            OPT_NOINSTALL=1
            ;;
        --force-sync)
            # FORCE SYNCHRO
            OPT_FORCE=1
            ;;
        --local-ini)
            # USE LOCAL INI FILE
            OPT_LOCAL=1
            ;;
        --no-install)
            OPT_NOINSTALL=1
            ;;
        --deploy-seq)
            # SPECIFIC DEPLOYMENT SEQUENCE
            OPT_SEQ=$VALUE
            ;;
        --prompt-deploy)
            # USE PROMPT DEPLOYMENT SEQUENCE
            OPT_PROMPT=1
            ;;
        *)
            echo "[ERROR] unknown parameter \"$PARAM\""
            usage
            exit 1
            ;;
    esac
    shift
done

echo '-------------------- START oc_bestsets_downloader -----------------------'
initialize 0
[ $? -ne 0 ] && echo '[ERROR]: initialize!' && exit -1

if [ $OPT_SHOW -eq 1 ] || [ $OPT_PROMPT -eq 1 ]; then
    # SHOW PACKAGES
    echo '[LOAD|INI]: loading '${OC_FILE_INI}'...'
    cat ${OC_FILE_INI} | grep '# PACK '
fi

# PROMPT FOR PACKAGES SELECTION
[ $OPT_PROMPT -eq 1 ] && echo "> Select Package(s) for deployment (0,1,2,...): " && read OPT_SEQ

if [ $OPT_NOINSTALL -eq 0 ]; then
    source ${OC_FILE_INI} && echo '[LOAD|INI]: loading '${OC_FILE_INI}'...'
    download_install
fi

echo '--------------------  END oc_bestsets_downloader  -----------------------'
# END MAIN

exit 0

