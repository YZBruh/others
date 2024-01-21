#!/usr/bin/bash
# Samsung stock rom unpacker - By YZBruh

# Variables
ARCH=$(uname -m)
DIR=$(pwd)
PACKAGES=$DIR/bin
VERS=1.1.0

# File name protection
if [ ! -f sm-soft-unpacker-generic.sh ]; then
    abort "==> You were warned not to change the file name!"
fi

## Functions

abort() {
    echo "$1"
    if [ -d $DIR/temp ]; then
        rm -rf $DIR/temp
    fi
    exit 1
}

menu() {
    clear
    echo "__________________________________"
    echo "|      Samsung ROM unpacker      |"
    echo "|             V1.1.0             |"
    echo "|           By YZBruh            |"
    echo "|________________________________|"
    echo "| Select option:                 |"
    echo "|   [1] Normal extract           |"
    echo "|   [2] Generate DumprX ROM      |"
    echo "|   [3] Generate DumprX ROM (ND) |"
    echo "|   [4] Setup requirements       |"
    echo "|   [5] How to use               |"
    echo "|   [6] Help and informations    |"
    echo "|   [7] Exit                     |"
    echo "|________________________________|"
    read -p "==> Please select and enter option (number): " OPT
    case $OPT in
        1|1.|.1|[1|1]|[1])
            MODE=1
            extractor
            exit
        ;;
        2|2.|.2|[2|2]|[2])
            MODE=2
            extractor
            exit
        ;;
        3|3.|.3|[3|3]|[3])
            MODE=3
            extractor
            exit
        ;;
        4|4.|.4|[4|4]|[4])
            setup
            exit
        ;;
        5|5.|.5|[5|5]|[5])
            hwuse
        ;;
        6|6.|.6|[6|6]|[6])
            info
            exit
        ;;
        7|7.|.7|[7|7]|[7])
            echo "==> Good bye!"
            exit
        ;;
        *)
            abort "==> Invalid option!"
    esac
}

extractor() {
    set -e
    echo "==> Stock ROM is being searched in the folder..."
    if [ -f *.zip ]; then
        COMP_TYPE="zip"
    elif [ -f *.7z ]; then
        COMP_TYPE="7z"
    elif [ -f *.7zip]; then
        COMP_TYPE="7z"
        WARN="1"
    elif [ -f *.tgz ]; then
        COMP_TYPE="tgz [tar.gz]"
    elif [ -f *.tar.gz ]; then
        COMP_TYPE="tar.gz"
    elif [ -f *.tar ]; then
        COMP_TYPE="tar"
    elif [ -f *.tar.xz ]; then
        COMP_TYPE="tar.xz"
    elif [ -f *.rar ]; then
        COMP_TYPE="rar"
    else
        abort "==> Not found!"
    fi
    echo "==> Found stock ROM compressed with $COMP_TYPE"
    echo "==> Extracting archive..."
    if [ -d temp ]; then
        rm -rf temp
        mkdir temp
    else
        mkdir temp
    fi
    mkdir temp/firmware
    if [ "$COMP_TYPE" == "zip" ]; then
        mv *.zip temp/firmware
        cd temp/firmware
        unzip *.zip
        mv *.zip $DIR
    elif [ "$COMP_TYPE" == "7z" ]; then
        if [ "$WARN" == "1" ]; then
            mv *.7zip temp/firmware
            cd temp/firmware
            7z x *.7zip
            mv *.7zip $DIR
        else
            mv *.7z temp/firmware
            cd temp/firmware
            7z x *.7z
            mv *.7z $DIR
        fi
    elif [ "$COMP_TYPE" == "tar.gz" ]; then
        mv *.tar.gz temp/firmware
        cd temp/firmware
        tar -xf *.tar.gz
        mv *.tar.gz $DIR
    elif [ "$COMP_TYPE" == "tgz [tar.gz]" ]; then
        mv *.tgz temp/firmware
        cd temp/firmware
        tar -xf *.tgz
        mv *.tgz $DIR
    elif [ "$COMP_TYPE" == "tar" ]; then
        mv *.tar temp/firmware
        cd temp/firmware
        tar -xf *.tar
        mv *.tar $DIR
    elif [ "$COMP_TYPE" == "tar.xz" ]; then
        mv *.tar.xz temp/firmware
        cd temp/firmware
        tar -xf *.tar.xz
        mv *.tar.xz $DIR
    elif [ "$COMP_TYPE" == "rar" ]; then
        mv *.rar temp/firmware
        cd temp/firmware
        unrar *.rar
        mv *.rar $DIR
    else
        abort "==> Failed!"
    fi
    cd $DIR/temp/firmware
    echo "==> Starting extracting tar.md5 packages..."
    if [ -f *AP*.tar.md5 ]; then
        mkdir AP
        mv *AP*.tar.md5 $(pwd)/AP/
        cd AP
        echo "==> Extracting AP..."
        tar -xf *AP*.tar.md5
        if [ "$?" == "0" ]; then
            echo "==> AP extracted."
        else
            abort "==> Failed!"
        fi
        cd $DIR/temp/firmware
    fi
    if [ -f *BL*.tar.md5 ]; then
        mkdir BL
        mv *BL*.tar.md5 $(pwd)/BL/
        cd BL
        echo "==> Extracting BL..."
        tar -xf *BL*.tar.md5
        if [ "$?" == "0" ]; then
            echo "==> BL extracted."
        else
            abort "==> Failed!"
        fi
        cd $DIR/temp/firmware
    fi
    if [ -f *CP*.tar.md5 ]; then
        mkdir CP
        mv *CP*.tar.md5 $(pwd)/CP/
        cd CP
        echo "==> Extracting CP..."
        tar -xf *CP*.tar.md5
        if [ "$?" == "0" ]; then
            echo "==> CP extracted."
        else
            abort "==> Failed!"
        fi
        cd $DIR/temp/firmware
    fi
    if [ -f *CSC*.tar.md5 ]; then
        mkdir CSC
        mv *CSC*.tar.md5 $(pwd)/CSC/
        cd CSC
        echo "==> Extracting CSC..."
        tar -xf *CSC*.tar.md5
        if [ "$?" == "0" ]; then
            echo "==> CSC extracted."
        else
            abort "==> Failed!"
        fi
        cd $DIR/temp/firmware
    fi
    if [ -f *HOME*.tar.md5 ]; then
        mkdir HOME
        mv *HOME*.tar.md5 $(pwd)/HOME/
        cd HOME
        echo "==> Extracting HOME..."
        tar -xf *HOME*.tar.md5
        if [ "$?" == "0" ]; then
            echo "==> HOME extracted."
        else
            abort "==> Failed!"
        fi
        cd $DIR/temp/firmware
    fi
    echo "==> Extracting lz4 packages..."
    cd AP
    unlz4 --rm *.lz4
    if [ "$?" == "0" ]; then
        cd $(pwd)
    else
        abort "==> Failed!"
    fi
    rm -rf *.tar.md5
    cd $DIR/temp/firmware/CP
    unlz4 --rm *.lz4
    if [ "$?" == "0" ]; then
        cd $(pwd)
    else
        abort "==> Failed!"
    fi
    rm -rf *.tar.md5
    cd $DIR/temp/firmware/BL
    unlz4 --rm *.lz4
    if [ "$?" == "0" ]; then
        cd $(pwd)
    else
        abort "==> Failed!"
    fi
    rm -rf *.tar.md5
    cd $DIR/temp/firmware/CSC
    unlz4 --rm *.lz4
    if [ "$?" == "0" ]; then
        cd $(pwd)
    else
        abort "==> Failed!"
    fi
    rm -rf *.tar.md5
    cd $DIR/temp/firmware/HOME
    if [ -f *.lz4 ]; then
        unlz4 --rm *.lz4
        if [ "$?" == "0" ]; then
            cd $(pwd)
        else
            abort "==> Failed!"
        fi
        rm -rf *.tar.md5
    fi
    cd $DIR
    if [ -d output ]; then
        rm -rf output
        mkdir output
    else
        mkdir output
    fi
    if [ "$MODE" == "1" ]; then
        echo "==> Moving files..."
        mv $DIR/temp/firmware/* $DIR/output/
        rm -rf $DIR/temp
        echo "==> Successfull!"
        echo "==> ROM: $DIR/output "
    elif [ "$MODE" == "2" ]; then
        cd $DIR/temp/firmware
        zip -r DumprX_Compatible_ROM.zip *
        mv *.zip $DIR/output/
        rm -rf $DIR/temp
        echo "==> Successfull!"
        echo "==> ROM: $DIR/output"
        
    elif [ "$MODE" == "3" ]; then
        cd $DIR/temp/firmware
        zip -r DumprX_Compatible_ROM.zip *
        mv *.zip $DIR/output/
        mv * $DIR/output/
        rm -rf $DIR/temp
        echo "==> Successfull!"
        echo "==> ROM: $DIR/output"
    else
        abort "==> Failed!"
    fi
    exit
}

setup() {
    case $ARCH in
        armv7l|aarch64)
            echo "==> Intalling packages..."
            pkg install -y zip p7zip tar xz-utils gzip unrar lz4
            if [ "$?" == "0" ]; then
                echo "==> Successfull!"
            else
                abort "==> Failed!"
            fi
        ;;
        x86|amd64)
            sudo apt install -y zip p7zip tar xz-utils gzip unrar lz4
            if [ "$?" == "0" ]; then
                echo "==> Successfull!"
            else
                abort "==> Failed!"
            fi
        ;;
        *)
            abort "Architecture was not determined!"
    esac
}

hwuse() {
    echo
    echo "Samsung ROM unpacker V"$VERS"-generic"
    echo
    echo "Run; ./sm-soft-unpacker-generic.sh"
    echo "Run with sudo if you are using linux; sudo ./sm-soft-unpacker-generic.sh"
    echo "The menu will be displayed..."
    echo "Type the option number (there are protection against some false spelling errors)."
    echo "The transaction will begin. Each transaction result is made out."
    echo "Or you can use flags."
    
    exit
}

info() {
    echo
    echo "Samsung ROM unpacker V"$VERS"-generic"
    echo
    echo "Funtions descriptions;"
    echo "   Normal extract: ROM is extracted and the output folder where you find the script is located."
    echo
    echo "   Generate DumprX ROM: ROM is extracted. The following extraction is compressed in zip format and will be in the output folder where the script is located. Extracted files are deleted."
    echo
    echo "   Generate DumprX ROM (ND): ROM is extracted. The following extraction is compressed in zip format and will be in the output folder where the script is located. Extracted files are not deleted and moved to the output folder on them."
    echo
    echo "Flags;"
    echo "   --menu OR -m"
    echo "   --normal OR -n"
    echo "   --dumprx OR -dx"
    echo "   --dumprx-nd OR -dxn"
    echo "   --howtouse OR -h"
    echo "   --info OR -i"
    echo "   --setup OR -s"
    echo
    echo "Supported file formats (stock ROM);"
    echo "   zip"
    echo "   tar"
    echo "   tgz"
    echo "   tar.gz"
    echo "   tar.xz"
    echo "   7z"
    echo "   rar"
    echo
    echo "Contact;"
    echo "   YZBruh"
    echo
    echo "End of informations..."
}

##

# Start progress
case $1 in
    --normal|-n)
        clear
        MODE=1
        extractor
        exit
    ;;
    --dumprx|-dx)
        clear
        MODE=2
        extractor
        exit
    ;;
    --dumprx-nd|-dxn)
        clear
        MODE=3
        extractor
        exit
    ;;
    --howtouse|-h)
        hwuse
        exit
    ;;
    --info|-i)
        info
        exit
    ;;
    --setup|-s)
        clear
        setup
        exit
    ;;
    --menu|-m)
        menu
        exit
    ;;
    *)
        menu
esac

# end of script
