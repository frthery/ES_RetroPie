#!/bin/bash

# CONFIGURE YOUR ROMS PATH
ROM_PATH='./roms'

# FUNCTIONS
function check_install_unrar() {
    [ -f /usr/bin/unrar-nonfree ] && echo [CHECK]: unrar-nonfree OK! && return 0

    #sudo deb-src http://mirrordirector.raspbian.org/raspbian/ wheezy main contrib non-free rpi
    #sudo apt-get update

    pushd ${OC_TMP_PATH}
    sudo apt-get build-dep unrar-nonfree
    sudo apt-get source -b unrar-nonfree
    #sudo dpkg -i unrar_*_armhf.deb
    popd

    [ -f /usr/bin/unrar-nonfree ] && echo [CHECK]: unrar-nonfree OK! && return 0
    [ ! -f /usr/bin/unrar-nonfree ] && echo [CHECK]: unrar-nonfree KO! && return 1
}

function check_install_megatools() {
    [ -f /usr/local/bin/megadl ] && echo [CHECK]: megatools OK! && return 0

    sudo apt-get --assume-yes install gcc build-essential libcurl4-openssl-dev libglib2.0-dev glib-networking
    wget http://megatools.megous.com/builds/megatools-1.9.94.tar.gz -P ${OC_TMP_PATH}
    tar -xvzf megatools-1.9.94.tar.gz -C ${OC_TMP_PATH}
    pushd ${OC_TMP_PATH}/megatools-1.9.94
    ./configure --disable-shared
    make
    #sudo make install
    popd

    [ -f /usr/local/bin/megadl ] && echo [CHECK]: megatools OK! && return 0
    [ ! -f /usr/local/bin/megadl ] && echo [CHECK]: unrar-nonfree KO! && return 1
}

function initialize() {
    local clearRoms=$1

    [ ! -d ${OC_PATH} ] && mkdir ${OC_PATH} && echo '[INIT]: create folder '${OC_PATH}

    # CLEAN
    [ -d ${OC_TMP_PATH} ] && rm -R ${OC_TMP_PATH} && echo '[CLEAN]: remove folder '${OC_TMP_PATH}
    [ -d ${OC_DWL_PATH} ] && rm -R ${OC_DWL_PATH} && echo '[CLEAN]: remove folder '${OC_DWL_PATH}
    [ $clearRoms == 1 ] && [ -d ${ROM_PATH} ] && rm -R ${ROM_PATH} && echo '[CLEAN]: remove folder '${ROM_PATH}

    # CREATE FOLDERS
    mkdir ${OC_TMP_PATH} && echo '[INIT]: create folder '${OC_TMP_PATH}
    mkdir ${OC_DWL_PATH} && echo '[INIT]: create folder '${OC_DWL_PATH}
    [ ! -d ${ROM_PATH} ] && mkdir ${ROM_PATH} && echo '[INIT]: create folder '${ROM_PATH}

    # UPDATE SYNC FILE
    touch $OC_FILE_SYNC

    # CHECK INSTALL MEGATOOLS, UNRAR-NONFREE, TODO DL OC_INI_DWL
    check_install_unrar || return 1;
    check_install_megatools || return 1;

    return 0
}

function download_install() {
    local seq=0
    local idx=0

    #while [ "${packs[$idx]}" != "" ]; do
    while [ $seq -lt ${#deploy_seq[@]} ]; do
        #__ERRMSGS=""

        idx=${deploy_seq[$seq]}
        if [ "${packs[$idx]}" == "" ];then
            echo '[WARNING]: pack not found, check deploy_seq into .ini file!'
           ((seq++))
           continue
        fi

        local infos=($(echo ${packs[$idx]} | sed 's/,/\n/g'))
        local files=($(echo ${pack_names[$idx]} | sed 's/,/\n/g'))
        #echo [FOUND: ${infos[0]}]: ${pack_names[$idx]}... && echo ${pack_links[$idx]}

        # CHECK SYNCHRO
        if [ $opt_force -eq 0 ]; then
            cat ${OC_FILE_SYNC} | grep "DOWNLOAD|UNRAR: ${infos[0]}" > /dev/null
            SYNC=$?
            [ $SYNC -eq 0 ] && echo [IS_SYNC: ${infos[0]}]: ${pack_names[$idx]} && ((seq++))
            [ $SYNC -eq 0 ] && continue
        fi

        # DOWNLOAD BESTSET
        echo [DOWNLOAD: ${infos[0]}]: ${pack_names[$idx]}... && echo ${pack_links[$idx]}
        megadl ${pack_links[$idx]} --path ${OC_DWL_PATH} 2> /dev/null
        DDL=$?

        [ $DDL -ne 0 ] && echo [ERROR DOWNLOAD: ${infos[0]}]: ${pack_names[$idx]} && ((seq++)) 
        [ $DDL -ne 0 ] && continue

        # CREATE OUTPUT FOLDER
        [ ! -d ${ROM_PATH}/${infos[1]} ] && mkdir ${ROM_PATH}/${infos[1]} && echo '[INIT]: create folder '${ROM_PATH}/${infos[1]}

        # UNRAR BESTSET
        echo [UNRAR]: ${files[0]} to ${ROM_PATH}/${infos[1]}...
        unrar-nonfree e -o+ ${OC_DWL_PATH}/${files[0]} ${ROM_PATH}/${infos[1]}
        UNRAR=$?

        [ $UNRAR -ne 0 ] && echo [ERROR UNRAR] package ${infos[0]}! && ((seq++)) 
        [ $UNRAR -ne 0 ] && continue

        # check errors
        #[ -z "$__ERRMSGS" ] || logger 1 "ERROR: $__ERRMSGS"

        now=`date +%Y%m%d`
        echo '[DOWNLOAD|UNRAR: '${infos[0]}']': ${pack_names[$idx]}': OK'
        echo '['$now'] [DOWNLOAD|UNRAR: '${infos[0]}']: '${pack_names[$idx]}': OK' >> ${OC_FILE_SYNC}

        ((seq++))
    done
}
#END FUNCTIONS

# GLOBAL VARIABLES
OC_LINK_FILE_INI='https://mega.co.nz/#!OVRDnAJb!bX5bhxhZ-XxprC9KF6IWVzMv2BWen519DJ7ULZ-q8ME'
OC_FILE_INI='oc_bestsets.ini'
OC_FILE_SYNC=${ROM_PATH}'/oc_bestsets_sync'
OC_PATH='./oc_bestsets_downloader'
OC_TMP_PATH=${OC_PATH}'/tmp'
OC_DWL_PATH=${OC_PATH}'/dwl'
# END GLOBAL VARIABLES

# MAIN

opt_force=0
opt_local=0

while [ "$1" != "" ]; do
    PARAM=`echo $1 | awk -F= '{print $1}'`
    VALUE=`echo $1 | awk -F= '{print $2}'`
    case $PARAM in
        -h | --help)
            #usage
            exit
            ;;
        -f | --force)
            # FORCE SYNCHRO
            opt_force=1
            ;;
        -l | --local)
            # USE LOCAL INI FILE
            opt_local=1
            ;;
        *)
            echo "[ERROR] unknown parameter \"$PARAM\""
            #usage
            exit 1
            ;;
    esac
    shift
done

echo '-------------------- START oc_bestsets_downloader -----------------------'
initialize 0

if [ $? -eq 0 ]; then
    [ $opt_local -eq 0 ] && [ -f ${OC_FILE_INI} ] && mv ${OC_FILE_INI} ${OC_FILE_INI}.old
    [ $opt_local -eq 0 ] && megadl ${OC_LINK_FILE_INI} 2> /dev/null && echo '[GET|LOAD]: '${OC_FILE_INI}

    if [ -f ${OC_FILE_INI} ]; then
        source ${OC_FILE_INI} && echo '[LOAD]: '${OC_FILE_INI}
        download_install
    else
        echo '[ERROR]: not ini file ['${OC_FILE_INI}'] found!' && exit -1
    fi
else
    echo '[ERROR]: initialize!' && exit -1
fi

echo '--------------------  END oc_bestsets_downloader  -----------------------'
exit 0
# END MAIN


