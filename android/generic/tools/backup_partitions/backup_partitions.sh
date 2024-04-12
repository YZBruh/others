#!/system/bin/sh
# By YZBruh - Yağız

# Yedekleme dizini
backup_dir="/sdcard/ROM_BACKUP_$(getprop ro.product.device)_$(date '+%Y%m%d')"
mkdir -p "$backup_dir"

# biraz bilgi verelim
echo "            --- Cihaz bilgisi ---"
echo "Kod adı: $(getprop ro.product.device)"
echo "Model kodu: $(getprop ro.product.model)"
echo "Mimari: $(getprop ro.product.cpu.abi)"
echo "VNDK (Vendor) sürümü: $(getprop ro.vndk.version)"
echo "Üretici: $(getprop ro.product.brand)"
echo "_______________________________________________"
echo
echo "Yedek dizini: $backup_dir"
echo "/dev bloğunun bilgisi alınıyor..."
sleep 3

devmodern="/dev/block/by-name"
devstale="/dev/block/platform/bootdevice/by-name"
# dev bloğunu belirle
if [ -d $devmodern ] && [ -f $devmodern/boot ]; then
    devblock=$devmodern
else if [ -d $devstale ] && [ $devstale/boot ]; then
    devblock=$devstale

# by-name içeriğini yedekle
for partition in $(ls $devblock); do
    echo "Yedekleniyor: $partition..."
    dd if="$devblock/$partition" of="$backup_dir/$partition.img" status=none
done

echo "Yedekleme tamamlandı."
echo "NOT: Büyük boyutlu EXT dosya sistemli bölümlerin boyutlarını yedeklerini tasarruf açısından resize2fs ile yeniden boyutlandırabilirsiniz."
exit
