#!/usr/bin/bash
# TARMD5 Packager - By YZBruh - Main script - Ana skript

# Variables - Değişkenler
DIR=$(pwd)
ARCH=$(uname -m)
TERMUX_PATH=/data/data/com.termux/files/usr/bin
if [ -d /usr/bin ]; then
    TARGET_PATH=/usr/bin
elif [ -d $TERMUX_PATH ]; then
    TARGET_PATH=$TERMUX_PATH
fi
if [ -f $TARGET_PATH/packager-generic ]; then
    if [ -d $TERMUX_PATH/bin ]; then
        BIN=$TERMUX_PATH/bin
    elif [ -d /usr/bin/bin ]; then
        BIN=/usr/bin/bin
    else
        echo "No pre-built packages have been found! Please make sure that there is no problem in the Packer integrity!"
        exit 1
    fi
elif [ -f $DIR/packager-generic.sh ]; then
    if [ -d $DIR/bin ]; then
        BIN=$DIR/bin
    else
        echo "No pre-built packages have been found! Please make sure that there is no problem in the Packer integrity!"
        exit 1
    fi
fi
VERS="1.4.0-PowerX"

## Functions - Fonksiyonlar :)

info_message() {
    echo "This script is an utility script created for the Samsung flash tool."
    echo "It is a response to the question of 'how to create tar.md5' especially experienced in TWRP or similar flash. :)"
}

help_message() {
    echo "For extract: ./packager-generic.sh"
    echo "See info's: ./packager-generic.sh -i OR --info"
    echo "Linux users should execute with sudo while packing operations!"
}

abort() {
    echo "$1"
    if [ -d $DIR/temp ]; then
        rm -rf $DIR/temp
    fi
    if [ "$WARN_CODE" == "1" ]; then
        if [ -f $DIR/*.img ]; then
            rm -f *.img
        fi
    elif [ "$WARN_CODE" == "2" ]; then
        if [ -f $DIR/*.img ]; then
            rm -f *.img
        fi
    fi
    exit 1
}

setup_bin() {
    if [ -d temp ]; then
        rm -rf temp
        mkdir --mode=777 temp
    else
        mkdir --mode=777 temp
    fi
    chmod 777 $BIN && chmod -R 777 $BIN/$ARCH && cp -r $BIN/$ARCH $DIR/temp/$ARCH
    if [ "$?" == "0" ]; then
        cd $DIR
    else
        abort "==> A mistake occurred when the packets were prepared!"
    fi
}

##

# File name protection - Dosya adı koruması
if [ -f packager-generic.sh ]; then
    cd $DIR
elif [ -f /data/data/com.termux/files/usr/bin/packager-generic ]; then
    cd $DIR
elif [ -f /usr/bin/packager-generic ]; then
    cd $DIR
else
    abort "File name has been modified!"
fi

## Start progress - İşlemlere başlayalım!
case $1 in
    -h|--help)
        help_message
        exit
    ;;
    -i|--info)
        info_message
        exit
    ;;
    -v|--version)
        echo $VERS
        exit
    ;;
    -l|--lz4)
        WARN_CODE=1
    ;;
    -a|--AP)
        WARN_CODE=2
esac

clear
echo "________________________________"
echo "|                              |"
echo "|       TAR.MD5 Packager       |"
echo "|           By YZBruh          |"
echo "|         1.4.0-PowerX         |"
echo "|______________________________|"
setup_bin

# Search the image in the directory - İmajı dizinde ara
if [ "$WARN_CODE" == "1" ]; then
    IMAGE=$(basename *.lz4)
elif [ "$WARN_CODE" == "2" ]; then
    IMAGE=$(basename *.tar.md5)
else
    if [ -f *.img ]; then
        IMAGE=$(basename *.img)
        WARN_CODE=0
    elif [ -f *.lz4 ]; then
        IMAGE=$(basename *.lz4)
        WARN_CODE=1
    elif [ -f *.tar.md5 ]; then
        IMAGE=$(basename *.tar.md5)
        WARN_CODE=2
    else
        abort "==> Image or archive (lz4 - tar.md5) not found!"
    fi
fi

# Do extraction operations if lz4 or AP is detected - Eğer lz4 veya AP algılandı ise ayıklama işlemlerini yap
if [ "$WARN_CODE" == "0" ]; then
    echo "==> Classic image detected."
elif [ "$WARN_CODE" == "1" ]; then
    echo "==> Found compressed image with lz4. Extracting..."
    cp $DIR/temp/$ARCH/lz4 .
    ./lz4 -dq $IMAGE
    if [ "$?" == "0" ]; then
        unset IMAGE
        rm -f lz4
    else
        abort "==> Failed!"
    fi
    IMAGE=$(basename *.img)
elif [ "$WARN_CODE" == "2" ]; then
    echo "==> AP found. Extracting..."
    IMAGE_NAME=$IMAGE
    mkdir temp/AP
    mv $IMAGE temp/AP/$IMAGE
    cp $DIR/temp/$ARCH/tar temp/AP
    cd $DIR/temp/AP
    ./tar -xf $DIR/temp/AP/$IMAGE
    if [ "$?" == "0" ]; then
        mv $DIR/temp/AP/$IMAGE $DIR/$IMAGE
        cd $DIR
    else
        mv $DIR/temp/AP/$IMAGE $DIR/$IMAGE
        abort "==> Failed!"
    fi
    cd temp/AP
    rm -f tar
    unset IMAGE
    echo "==> Founded: "
    if [ -d metadata ]; then
        rm -rf metadata
    fi
    ls -1
    echo "==> Type the name of the file you will process (make sure you write correctly!) ."
    read IMAGE
    if [ -f $IMAGE ]; then
        echo "==> Extracting..."
        cp $DIR/temp/$ARCH/lz4 .
        ./lz4 -dq --rm $DIR/temp/AP/$IMAGE
        if [ "$?" == "0" ]; then
            rm -f *.lz4 lz4
            mv *.img $DIR
            unset IMAGE
            cd $DIR
            IMAGE=$(basename *.img)
        else
            abort "==> Failed!"
        fi
    else
        abort "==> A file with this name has not been found!"
    fi
fi

cd $DIR
case $ARCH in
    aarch64|amd64)
        echo "==> Image info:"
        echo "********************************"
        if [ "$ARCH" == "aarch64" ]; then
            cp $DIR/temp/aarch64/imjtool.android.arm64 .
            ./imjtool.android.arm64 $IMAGE
            if [ "$?" == "0" ]; then
                rm -f imjtool.android.arm64
            else
                echo "An error occurred when image information appears! Operations are underway."
            fi
        elif [ "$ARCH" == "amd64" ]; then
            cp $DIR/temp/amd64/imjtool.ELF64 .
            ./imjtool.ELF64 $IMAGE
            if [ "$?" == "0" ]; then
                rm -f imjtool.ELF64
            else
                echo "An error occurred when image information appears! Operations are underway."
            fi
        fi
        echo "********************************"
esac
cd $DIR
echo "==> Packing..."
cp $DIR/temp/$ARCH/tar .
./tar -H ustar -c *.img > "$IMAGE".tar
if [ "$?" == "0" ]; then
    echo "==> Adding md5sum signature..."
    rm -rf tar
else
    abort "==> Failed!"
fi
if [ -f *.tar.md5 ]; then
    mv *.tar.md5 temp/
fi
cp $DIR/temp/$ARCH/md5sum .
./md5sum -b -t "$IMAGE".tar >> "$IMAGE".tar
if [ "$?" == "0" ]; then
    rm -f md5sum
    mv "$IMAGE".tar "$IMAGE".tar.md5
    unset IMAGE
    IMAGE=$(basename *.tar.md5)
else
    abort "==> Failed!"
fi

if [ -d out ]; then
    rm -rf out
    mkdir out
else
    mkdir out
fi
if [ "$WARN_CODE" == "1" ] && [ -f $DIR/*.img ]; then
    rm -f $DIR/*.img
elif [ "$WARN_CODE" == "2" ] && [ -f $DIR/*.img ]; then
    rm -f $DIR/*.img
fi
mv $IMAGE $DIR/out/$IMAGE
if [ -f temp/*.tar.md5 ]; then
    mv temp/*.tar.md5 .
fi
rm -rf $DIR/temp
echo "==> Succesfull!"
exit

##

# end of script
