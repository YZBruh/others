#!/system/bin/sh
# By YZBruh - Yağız

# Yedekleme dizini
backup_dir="/sdcard/ROM_BACKUP_$(getprop ro.product.device)_$(date '+%Y%m%d')"

# biraz bilgi verelim
echo "            --- Cihaz bilgisi ---"
echo "Kod adı: $(getprop ro.product.device)"
echo "Model kodu: $(getprop ro.product.model)"
echo "Mimari: $(getprop ro.product.cpu.abi)"
echo "VNDK (Vendor) sürümü: $(getprop ro.vndk.version)"
echo "Üretici: $(getprop ro.product.brand)"
echo "_______________________________________________"

printf "Kendiniz bir yedek dizini ayarlamak istermisiniz? (y/n): "
read status

if [[ "$status" == "y" ]]; then
    unset backup_dir
    printf "Yedek dizinini yazın: "
    read backup_dir
    if [ ! -d $backup_dir ]; then
        echo "Böyle bir dizin bulunamadı: $backup_dir"
        echo "Oluşturmak istermisiniz? (y/n)"
        read pass
        if [[ "$pass" == "y" ]]; then
            mkdir $backup_dir
        elif [[ "$pass" == "n" ]]; then
            echo "Dizin yok = yedek yok"
            exit 1
        else
            echo "Bilinmeyen seçenek: $pass"
        fi
    fi
elif [[ "$status" == "n" ]]; then
    echo "Yedek dizini otomatik oluşturuluyor..."
    mkdir -p "$backup_dir"
else
    echo "Bilinmeyen seçenek: $status"
    exit 1
fi
echo
echo "Yedek dizini: $backup_dir"
echo "/dev bloğunun bilgisi alınıyor..."
sleep 3

devmodern="/dev/block/by-name"
devstale="/dev/block/platform/bootdevice/by-name"
# dev bloğunu belirle
if [ -d $devmodern ] && [ -f $devmodern/boot ]; then
    devblock=$devmodern
elif [ -d $devstale ] && [ $devstale/boot ]; then
    devblock=$devstale
else
    echo "/dev bloğu bulunamadı!"
    exit 1
fi

# by-name içeriğini yedekle
for partition in $(ls $devblock); do
    if [[ "$partition" == "userdata" ]]; then
        echo "userdata bölümü atlanıyor..."
    else
        echo "Yedekleniyor: $partition..."
        dd if="$devblock/$partition" of="$backup_dir/$partition.img"
    fi
done

echo "Yedekleme tamamlandı."
echo "NOT: Büyük boyutlu EXT dosya sistemli bölümlerin boyutlarını yedeklerini tasarruf açısından resize2fs ile yeniden boyutlandırabilirsiniz."
exit
