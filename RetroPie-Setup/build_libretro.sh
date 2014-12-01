#!/bin/bash

# FUNCTIONS
__mod_idx=()
__mod_id=()
__mod_desc=()
__mod_menus=()
__doPackages=0

# function from: https://github.com/petrockblog/RetroPie-Setup/blob/master/scriptmodules/packages.sh
function rp_registerFunction() {
    __mod_idx+=($1)
    __mod_id[$1]=$2
    __mod_desc[$1]=$3
    __mod_menus[$1]=$4
}

# function from: https://github.com/petrockblog/RetroPie-Setup/blob/master/scriptmodules/packages.sh
function registerModule() {
    local module_idx="$1"
    local module_path="$2"
    local rp_module_id=""
    local rp_module_desc=""
    local rp_module_menus=""
    local var
    local error=0
    source $module_path
    for var in rp_module_id rp_module_desc rp_module_menus; do
        if [[ "${!var}" == "" ]]; then
            echo "Module $module_path is missing valid $var"
            error=1
        fi
    done
    [[ $error -eq 1 ]] && exit 1

    rp_registerFunction "$module_idx" "$rp_module_id" "$rp_module_desc" "$rp_module_menus"
}

# function from: https://github.com/petrockblog/RetroPie-Setup/blob/master/scriptmodules/packages.sh
function registerModuleDir() {
    local module_idx="$1"
    local module_dir="$2"
    for module in `find "$scriptdir/scriptmodules/$2" -maxdepth 1 -name "*.sh" | sort`; do
        registerModule $module_idx "$module"
        ((module_idx++))
    done
}

# function from: https://github.com/petrockblog/RetroPie-Setup/blob/master/scriptmodules/packages.sh
function registerAllModules() {
    registerModuleDir 100 "emulators" 
    registerModuleDir 200 "libretrocores" 
    registerModuleDir 300 "supplementary"
}

function showModules() {
    local module_idx=$1
    while [ "${__mod_id[$module_idx]}" != "" ]; do
        logger 0 "Register Module: [$module_idx] ${__mod_id[$module_idx]}"

        ((module_idx++))
    done
}

function showModuleFunctions() {
    local mod_id=$1

    if [ "$mod_id" != '' ]; then
        local funcDepends="depends_${mod_id}"
        local funcSrc="sources_${mod_id}"
        local funcBuild="build_${mod_id}"
        local funcInstall="install_${mod_id}"
        local funcConfigure="configure_${mod_id}"
        local functions=""

        fn_exists $funcDepends && functions+="$funcDepends "
        fn_exists $funcSrc && functions+="$funcSrc "
        fn_exists $funcBuild && functions+="$funcBuild "
        fn_exists $funcInstall && functions+="$funcInstall "
        fn_exists $funcConfigure && functions+="$funcConfigure "

        logger 1 "MOD: [$mod_id] [ $functions ]"
    fi
}

function execModule() {
    local mod_id=$1

    #func="${func}_${mod_id}"
    local funcDepends="depends_${mod_id}"
    local funcSrc="sources_${mod_id}"
    local funcBuild="build_${mod_id}"
    local funcInstall="install_${mod_id}"
    local funcConfigure="configure_${mod_id}"

    if [ $opt_build -eq 1 ]; then
        # echo "Checking, if function ${!__function} exists"
        fn_exists $funcSrc || logger 0 "WARN: function -> $funcSrc not found" # __ERRMSGS="function -> $funcSrc not found"
        fn_exists $funcBuild || logger 0 "WARN: function -> $funcBuild not found" # __ERRMSGS="function -> $funcBuild not found"
        #[ -z "$__ERRMSGS" ] || return
    fi

    # echo "Printing function name"
    #logger "$desc ${__mod_desc[$idx]}"

    # echo "Executing function"
    if fn_exists $funcDepends; then
        logger 1 "EXEC: [$mod_id] function -> $funcDepends"
        $funcDepends
    fi
    if [ $opt_build -eq 1 ] && fn_exists $funcSrc; then
        logger 1 "EXEC: [$mod_id] function -> $funcSrc"
        $funcSrc
    fi
    if [ $opt_build -eq 1 ] && fn_exists $funcBuild; then
        logger 1 "EXEC: [$mod_id] function -> $funcBuild"
        $funcBuild

        # check compilation errors
        [ -z "$__ERRMSGS" ] || return
    fi

    if [ $opt_install -eq 1 ] && fn_exists $funcInstall; then
        logger 1 "EXEC: [$mod_id] function -> $funcInstall"
        $funcInstall
    fi

    if [ $opt_configure -eq 1 ] && fn_exists $funcConfigure; then
        logger 1 "EXEC: [$mod_id] function -> $funcConfigure"
        $funcConfigure
    fi
}

function execAllModules() {
    local module_idx=$1
    while [ "${__mod_id[$module_idx]}" != "" ]; do
        #echo [$module_idx]
        execModule ${__mod_id[$module_idx]}

        # check errors
        [ -z "$__ERRMSGS" ] || logger 1 "ERROR: $__ERRMSGS"

        ((module_idx++))
    done
}

function logger() {
    [ $1 == 1 ] && echo -e "\n-----------------------------------------------------------\n$2\n-----------------------------------------------------------"
    [ $1 == 1 ] || echo $2
}

function usage() {
    echo "build_libretro.sh [-l|--list] [-a|--all] [-b|--build] [-i|--install] [-c|--configure] -name=[idx]"
}
# END FUNCTIONS

# GLOBAL VARIABLES
scriptdir=$(pwd)
default_rootdir='/opt/retropie/'
rootdir=$scriptdir/build
romdir='/home/pi/RetroPie/roms'
so_filter='*libretro*.so'

opt_build=0
opt_install=0
opt_configure=0
opt_all=0
opt_list=0
# END GLOBAL VARIABLES

# MAIN
# no arguments error
if [ "$1" = "" ]; then
    logger 0 "ERROR: no arguments found!"
    usage
    exit 1
fi

logger 1 "--- INITIALIZE --------------------------------------------"
source $scriptdir/scriptmodules/helpers.sh
logger 0 "LOADED: ./scriptmodules/helpers.sh"

while [ "$1" != "" ]; do
    PARAM=`echo $1 | awk -F= '{print $1}'`
    VALUE=`echo $1 | awk -F= '{print $2}'`
    case $PARAM in
        -h | --help)
            usage
            exit
            ;;
        -l | --list)
            opt_list=1
            ;;
        -a | --all)
            opt_build=1
            opt_install=1
            opt_configure=1
			rootdir=$default_rootdir
            ;;
        -b | --build)
            opt_build=1
            ;;
        -i | --install)
            opt_install=1
            rootdir=$default_rootdir
            ;;
        -c | --configure)
            opt_configure=1
            ;;
        -name)
            [ $VALUE = 'all' ] && opt_all=1
            mod_id=$VALUE
            ;;
        -f | --filter)
            so_filter=$VALUE
            ;;
        *)
            echo "ERROR: unknown parameter \"$PARAM\""
            usage
            exit 1
            ;;
    esac
    shift
done

#VERBOSE
logger 0 "OPTIONS: -build[$opt_build],-install[$opt_install],-config[$opt_configure],-all[$opt_all] filter:[$so_filter]"
logger 0 "DIR: scriptdir=[$scriptdir]"
logger 0 "DIR: rootdir=[$rootdir]"
logger 0 "DIR: romdir=[$romdir]"

registerModuleDir 100 "emulators" 
registerModuleDir 200 "libretrocores" 

#exit on --list option
if [ $opt_list -eq 1 ]; then
    logger 1 "--- EMULATORS ---------------------------------------------"
    showModules 100
    logger 1 "--- LIBRETROCORES -----------------------------------------"
    showModules 200

    showModuleFunctions $mod_id
    logger 1 "--- EXIT --------------------------------------------------"
    exit
fi

showModuleFunctions $mod_id

# init folders
[ ! -d $rootdir ] && mkdir $rootdir
[ ! -d $rootdir/emulatorcores ] && mkdir $rootdir/emulatorcores
[ ! -d $rootdir/emulators ] && mkdir $rootdir/emulators

if [ $opt_all -eq 1 ]; then
    # EXEC ALL MODULES
    execAllModules 100
    execAllModules 200
else
    # EXEC SPECIFIC MODULE
    execModule $mod_id

    # check errors
    [ -z "$__ERRMSGS" ] || logger 1 "ERROR: $__ERRMSGS"
fi

if [ $opt_build -eq 1 ] && [ "$rootdir" != "$default_rootdir" ]; then
    # copy cores to ./bin folder
    [ -d ./bin ] || mkdir ./bin
    logger 1 "COPY: $so_filter to ./bin"
    find $rootdir/emulatorcores/ -name $so_filter | xargs cp -t ./bin
fi

logger 1 "--- EXIT --------------------------------------------------"
exit 0
# END MAIN
