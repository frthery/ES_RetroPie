#!/bin/bash

#BUILD RPI: ./build_retropie.sh -b -name=?
#BUILD RPI2: FORMAT_COMPILER_TARGET=armv7-cortexa7-hardfloat MAKEFLAGS=-j4 ./build_retropie.sh -b -name=?
#BUILD WIN64: HOST_CC=x86_64-w64-mingw32 ./build_retropie.sh -b -name=?
#BUILD RPI: HOST_CC=mipsel-gcw0-linux ./build_retropie.sh -b -name=?
#CROSS COMPILATION ARM: HOST_CC=arm-linux-gnueabihf ./build_retropie.sh -b -name=?
#UBUNTU CROSS COMPILATION INSTALL: apt-get install gcc-arm-linux-gnueabihf && apt-get install g++-arm-linux-gnueabihf
#DEFAULT COMPILER: HOST_CC=default ./build_retropie.sh -b -name=?

#LIBRETRO SAMPLE: ARCH=x86_64 platform=win HOST_CC=x86_64-w64-mingw32 ./libretro-build.sh
#LIBRETRO SAMPLE: make -f Makefile platform=win CC="x86_64-w64-mingw32-gcc" CXX="x86_64-w64-mingw32-g++" -j7

# INIT COMPILER FLAGS
__default_cflags="-O2 -pipe -mfpu=vfp -march=armv6j -mfloat-abi=hard"
#__default_cflags="-O2 -mcpu=cortex-a7 -mfpu=neon-vfpv4 -mfloat-abi=hard"
__default_asflags=""
#__default_ldflags=""
__default_makeflags=""
__default_gcc_version="4.7"

if [ "$HOST_CC" ]; then
   if [ "$HOST_CC" = "mipsel-gcw0-linux" ]; then 
      # GCW TOOLCHAIN: http://boards.dingoonity.org/gcw-development/gcw-zero-toolchain-for-windows-(cygwin)-2013-10-04/
      FORMAT_COMPILER_TARGET="gcw0"

      export PATH=$PATH:/opt/gcw0-toolchain/usr/bin:/opt/gcw0-toolchain/usr/mipsel-gcw0-linux-uclibc/sysroot/usr/bin
      export PKG_CONF_PATH=/opt/gcw0-toolchain/usr/bin/pkg-config
      export PKG_CONFIG_PATH=/opt/gcw0-toolchain/usr/mipsel-gcw0-linux-uclibc/sysroot/usr/lib/pkgconfig
      export PKG_CONFIG_SYSROOT_DIR=/opt/gcw0-toolchain/usr/mipsel-gcw0-linux-uclibc/sysroot
      export PKG_CONFIG_LIBDIR=/opt/gcw0-toolchain/usr/mipsel-gcw0-linux/uclibc/sysroot/usr/lib/pkgconfig
   else
      #[ "$HOST_CC" = "arm-unknown-linux-gnueabi" ] && PATH_CC=/opt/cross/x-tools/arm-unknown-linux-gnueabi/bin && export PATH=$PATH_CC:$PATH

      [ "$HOST_CC" != "default" ] && export CC="\"${HOST_CC}-gcc\""
      [ "$HOST_CC" != "default" ] && export CXX="\"${HOST_CC}-g++\""
      #[ "$HOST_CC" != "default" ] && export STRIP=x86_64-w64-mingw32-strip
      [ "$HOST_CC" != "default" ] && export COMPILER="CC=${CC} CXX=${CXX}"

      [ "$HOST_CC" = "x86_64-w64-mingw32" ] || [ "$HOST_CC" = "i686-w64-mingw32" ] && FORMAT_COMPILER_TARGET="win"

      if [ "$HOST_CC" = "arm-unknown-linux-gnueabi" ] || [ "$HOST_CC" = "arm-linux-gnueabihf" ]; then
         #echo "--- CROSS COMPILATION ---"
        FORMAT_COMPILER_TARGET="armv6j-hardfloat"

        #[ "$HOST_CC" = "arm-unknown-linux-gnueabi" ] && __default_cflags+=" -I/opt/cross/x-tools/arm-unknown-linux-gnueabi/arm-unknown-linux-gnueabi/sysroot/usr/include "
        #/opt/cross/x-tools/arm-unknown-linux-gnueabi/arm-unknown-linux-gnueabi/sysroot/usr/lib
        #which gcc-arm-linux-gnueabi

        #export RANLIB=/opt/cross/x-tools/arm-unknown-linux-gnueabi/bin/arm-unknown-linux-gnueabi-ranlib
        #export STRIP=/opt/cross/x-tools/arm-unknown-linux-gnueabi/bin/arm-unknown-linux-gnueabi-strip
        #export CFLAGS="-I/opt/cross/x-tools/arm-unknown-linux-gnueabi/include"
        #export LDFLAGS="-L/opt/cross/x-tools/arm-unknown-linux-gnueabi/lib"

        #arm-unknown-linux-gnueabi-g++ --version
        #echo "--- $? ---"
      fi
   fi
else
   # default raspberry compilation
   [ -z "$FORMAT_COMPILER_TARGET" ] && FORMAT_COMPILER_TARGET="armv6j-hardfloat"
   [ "$FORMAT_COMPILER_TARGET" = "armv7-cortexa7-hardfloat" ] && __default_cflags="-O2 -mcpu=cortex-a7 -mfpu=neon-vfpv4 -mfloat-abi=hard"
fi

so_filter='*libretro*.so'
[ "$HOST_CC" = "x86_64-w64-mingw32" ] && so_filter='*libretro*.dll'

if [ "$FORMAT_COMPILER_TARGET" = "armv6j-hardfloat" ] || [ "$FORMAT_COMPILER_TARGET" = "armv7-cortexa7-hardfloat" ]; then
   [[ -z "${CFLAGS}" ]] && export CFLAGS="${__default_cflags}"
   [[ -z "${CXXFLAGS}" ]] && export CXXFLAGS="${__default_cflags}"
   #[[ -z "${LDFLAGS}" ]] && export LDFLAGS="${__default_ldflags}"
   [[ -z "${ASFLAGS}" ]] && export ASFLAGS="${__default_asflags}"
   [[ -z "${MAKEFLAGS}" ]] && export MAKEFLAGS="${__default_makeflags}"
fi
# END INIT COMPILER FLAGS

# FUNCTIONS
__mod_idx=()
__mod_id=()
__mod_desc=()
__mod_menus=()
__doPackages=0

# function from: https://github.com/petrockblog/RetroPie-Setup/blob/master/scriptmodules/packages.sh
# params: $1=index, $2=id, $3=type, $4=description, $5=menus,  $6=flags
function rp_registerFunction() {
    __mod_idx+=($1)
    __mod_id[$1]=$2
    __mod_type[$1]=$3
    __mod_desc[$1]=$4
    __mod_menus[$1]=$5
    __mod_flags[$1]=$6
}

# function from: https://github.com/petrockblog/RetroPie-Setup/blob/master/scriptmodules/packages.sh
function rp_registerModule() {
    local module_idx="$1"
    local module_path="$2"
    local module_type="$3"
    local rp_module_id=""
    local rp_module_desc=""
    local rp_module_menus=""
    local rp_module_flags=""
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
    rp_registerFunction "$module_idx" "$rp_module_id" "$module_type" "$rp_module_desc" "$rp_module_menus"  "$rp_module_flags"
}

# function from: https://github.com/petrockblog/RetroPie-Setup/blob/master/scriptmodules/packages.sh
function registerModuleDir() {
    local module_idx="$1"
    local module_dir="$2"
    
    for module in `find "$scriptdir/scriptmodules/$2" -maxdepth 1 -name "*.sh" ! -name "a_*.sh" | sort`; do
        rp_registerModule $module_idx "$module" "$module_dir"
        ((module_idx++))
    done
    for module in `find "$scriptdir/scriptmodules/$2" -maxdepth 1 -name "a_*.sh" | sort`; do
        rp_registerModule $module_idx "$module" "$module_dir"
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
        logger 0 "Module: [$module_idx] | ${__mod_id[$module_idx]} | [${__mod_desc[$module_idx]}]"

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
    # exit if no module idx
    [ "$1" = "" ] && return
    
    local mod_id=$1

    #func="${func}_${mod_id}"
    local funcDepends="depends_${mod_id}"
    local funcSrc="sources_${mod_id}"
    local funcBuild="build_${mod_id}"
    local funcInstall="install_${mod_id}"
    local funcConfigure="configure_${mod_id}"
    local funcCopy="copy_${mod_id}"

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
        [ -z "$__ERRMSGS" ] && logger 1 "SUCCESS: successfully compile ${mod_id}!"
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

    if [ $opt_build -eq 1 ] && fn_exists $funcCopy; then
        logger 1 "EXEC: [$mod_id] function -> $funcCopy"
        $funcCopy
    fi
}

function execModules() {
    # split modules
    local mods=($(echo $1 | sed 's/,/\n/g'))

    while [ "${mods[$module_idx]}" != "" ]; do
        __ERRMSGS=""

        showModuleFunctions ${mods[$module_idx]}
        # EXEC SPECIFIC MODULE
        execModule ${mods[$module_idx]}

        # check errors
        [ -z "$__ERRMSGS" ] || logger 1 "ERROR: $__ERRMSGS"
        ((module_idx++))
    done
}

function execAllModules() {
    local module_idx=$1
    while [ "${__mod_id[$module_idx]}" != "" ]; do
        __ERRMSGS=""
        
        showModuleFunctions ${mods[$module_idx]}
        # EXEC SPECIFIC MODULE
        execModule ${__mod_id[$module_idx]}

        # check errors
        [ -z "$__ERRMSGS" ] || logger 1 "ERROR: $__ERRMSGS"

        ((module_idx++))
    done
}

function updateModules() {
    [ -d temporary ] && rm -R ./tmp/*
    [ -f master.zip ] && rm master.zip

    logger 1 "WGET: ES_RetroPie to .tmp"
    wget --no-check-certificate http://github.com/frthery/ES_RetroPie/archive/master.zip
    unzip master.zip -d "./tmp"

    logger 1 "COPY: ES_RetroPie Modules"
    cp -R ./tmp/ES_RetroPie-master/RetroPie-Setup/scriptmodules/ ./
    cp -R ./tmp/ES_RetroPie-master/RetroPie-Setup/supplementary/ ./

    rm ./tmp/ES_RetroPie-master/RetroPie-Setup/build_retropie.sh
    cp ./tmp/ES_RetroPie-master/RetroPie-Setup/*.sh ./

    # clean
    logger 1 "CLEAN: ES_RetroPie ./tmp"
    rm -R ./tmp/* && rm master.zip
}

function setDefaultCompiler() {
    logger 1 "INSTALL: DEFAULT COMPILER gcc-4.7 g++-4.7"
    
    # install gcc-4.7 g++-4.7
    rps_checkNeededPackages git dialog gcc-4.7 g++-4.7
    # set default gcc version
    gcc_version $__default_gcc_version
}

function showCompilerFlags() {
    # SHOW COMPILER FLAGS
    logger 1 "--- COMPILER OPTIONS --------------------------------------"
    logger 0 "FORMAT_COMPILER_TARGET: [$FORMAT_COMPILER_TARGET]"
    logger 0 "HOST_CC:   [$HOST_CC]"
    logger 0 "COMPILER:  [$COMPILER]"
    #logger 0 "CC:        [$CC]"
    #logger 0 "CXX:       [$CXX]"
    logger 0 "CFLAGS:    [$CFLAGS]"
    logger 0 "CXXFLAGS:  [$CXXFLAGS]"
    logger 0 "LDFLAGS:  [$LDFLAGS]"
    logger 0 "ASFLAGS:   [$ASFLAGS]"
    logger 0 "MAKEFLAGS: [$MAKEFLAGS]"
    #echo "PATH: [$PATH]"
}

function logger() {
    now=$(date +"%m-%d-%y %r")

    [ $1 == 1 ] && echo -e "\n-----------------------------------------------------------\n$2\n-----------------------------------------------------------"
    #[ $1 == 1 ] && echo -e "\n-----------------------------------------------------------\n$2\n-----------------------------------------------------------" >> $log_file
    [ $1 == 1 ] || echo $2 
    #[ $1 == 1 ] || echo $2 >> $log_file
    echo -e [$now] - $2 >> $log_file
}

function usage() {
    echo "build_libretro.sh [-u|--update] [-l|--list] [-a|--all] [-b|--build] [-i|--install] [-c|--configure] -name=[idx,?]"
    #echo "variables: FORMAT_COMPILER_TARGET=? HOST_CC=?"
    echo ""
    echo "BUILD RPI: ./build_retropie.sh -b -name=?"
    echo "BUILD RPI2: FORMAT_COMPILER_TARGET=armv7-cortexa7-hardfloat MAKEFLAGS=-j4 ./build_retropie.sh -b -name=?"
    echo "BUILD WIN64: HOST_CC=x86_64-w64-mingw32 ./build_retropie.sh -b -name=?"
    echo "BUILD RPI: HOST_CC=mipsel-gcw0-linux ./build_retropie.sh -b -name=?"
}
# END FUNCTIONS

# GLOBAL VARIABLES
now=`date +%Y%m%d`
default_rootdir='/opt/retropie/'

scriptdir=$(pwd)
rootdir=$scriptdir/build
outputdir=$scriptdir/bin/$now
romdir='/home/pi/RetroPie/roms'

log_file=$scriptdir'/build_retropie.log'
[ -f $log_file ] && rm $log_file

__swapdir="$scriptdir/tmp/"
[ -f free ] && __memory=$(free -t -m | awk '/^Total:/{print $2}')

opt_update=0
opt_compiler=0
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
source $scriptdir/scriptmodules/packages.sh
logger 0 "LOADED: ./scriptmodules/packages.sh"


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
        -u | --update)
            opt_update=1
            ;;
        -compiler)
            opt_compiler=1
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
logger 0 "OPTIONS: -update[$opt_update],-build[$opt_build],-install[$opt_install],-config[$opt_configure],-all[$opt_all]"
logger 0 "OPTIONS: -name=[$mod_id]"
logger 0 "OPTIONS: filter:[$so_filter]"
logger 0 "DIR: scriptdir=[$scriptdir]"
logger 0 "DIR: rootdir=[$rootdir]"
logger 0 "DIR: swapdir=[$__swapdir]"
logger 0 "DIR: romdir=[$romdir]"
logger 0 "DIR: outputdir=[$outputdir]"

[ $opt_update -eq 1 ] && updateModules

registerModuleDir 100 "emulators" 
registerModuleDir 200 "libretrocores" 

#exit on --list option
if [ $opt_list -eq 1 ]; then
    logger 1 "--- EMULATORS ---------------------------------------------"
    showModules 100
    logger 1 "--- LIBRETROCORES -----------------------------------------"
    showModules 200

    showModuleFunctions $mod_id
    exit
fi

[ $opt_build -eq 1 ] && showCompilerFlags
[ $opt_build -eq 1 ] && [ $opt_compiler -eq 1 ] && setDefaultCompiler

# init folders
[ ! -d $rootdir ] && mkdir $rootdir
[ ! -d $scriptdir/bin ] && mkdir $scriptdir/bin
[ ! -d $outputdir ] && mkdir $outputdir
[ ! -d $rootdir/emulatorcores ] && mkdir $rootdir/emulatorcores
[ ! -d $rootdir/emulators ] && mkdir $rootdir/emulators

if [ $opt_all -eq 1 ]; then
    # EXEC ALL LIBRETRO MODULES
    #execAllModules 100
    execAllModules 200
else
    execModules $mod_id
fi

logger 1 "--- EXIT --------------------------------------------------"
[ $opt_build -eq 1 ] && cp $log_file $outputdir
# END MAIN

exit 0

