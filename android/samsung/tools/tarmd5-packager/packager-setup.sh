#!/usr/bin/bash
# TARMD5 Packager setup -- uninstall script By YZBruh - TARMD5 Packager kurum -- kaldırma skripti By YZBruh
set -e

# File name protection - Dosya adı koruması
if [ -f packager-setup.sh ]; then
    cd $(pwd)
else
    echo "File name has been modified!!"
    exit 1
fi

# Variables - Değişkenler
DIR=$(pwd)
if [ -d /usr/bin ]; then
    TARGET_PATH=/usr/bin
elif [ -d /data/data/com.termux/files/usr/bin ]; then
    TARGET_PATH=/data/data/com.termux/files/usr/bin
fi
VERS="1.4.0-PowerX"

## Functions - Fonksiyonlar
abort() {
    echo "$1"
    exit 1
}

progs() {
    if [ "$1" == "install" ]; then
        echo "Setupping..."
        cp -r $DIR/bin $TARGET_PATH
        cp $DIR/bin/class/packager-generic $TARGET_PATH
        chmod 777 $TARGET_PATH/packager-generic
        echo "Successfull!"
    elif [ "$1" == "uninstall" ]; then
        echo "Uninstalling..."
        rm -f $TARGET_PATH/packager-generic
        rm -rf $TARGET_PATH/bin
        echo "Successfull!"
    fi
}

##

# Start - Başla...
case $1 in
    -h|--help)
        echo "Usage: ./packager-setup.sh [flag]"
        echo "See flags: ./packager-setup.sh --flags OR -f"
        exit
    ;;
    -i|--info)
        echo "This is an add-in of the skript TAR.MD5 Packer. It is for full installation and removal."
        exit
    ;;
    -f|--flags)
        echo "Flags;"
        echo "   -h OR --help       ==> View the help message."
        echo "   -i OR --info       ==> Information about Script is given (for example what works)."
        echo "   -f OR --flags      ==> View flags."
        echo "   -v OR --version    ==> Version info."
        echo "   -s OR --setup      ==> Full installation of the packer is made."
        echo "   -u OR --uninstall  ==> Packer if you are fully installed."
        exit
    ;;
    -v|--version)
        echo $VERS
        exit
    ;;
    -s|--setup)
        progs install
    ;;
    -u|--uninstall)
        progs uninstall
    ;;
    *)
        abort "You have to use a flag in this script!"
esac

# end of file
