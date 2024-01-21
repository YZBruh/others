#!/usr/bin/bash
# GitHub depo yayını yükleyicisi - GitHub repository release uploader
# By YZBruh

# Directly exit
set -e

# Paket kurulumları - Package installatations
echo "Have the necessary packages been installed? (y/n | y=yes n=no)"
read PASS
if [ "$PASS" == "y" ]; then
   sudo apt update
   sudo apt -y install curl jq
elif [ "$PASS" == "n" ]; then
   echo "Skipping."
else
   echo "Invalid arguement!"
   exit 1
fi

# Bilgileri al - Get info's
echo
echo "GitHub repo release uploader V1 | By YZBruh"
read -p "User name (GitHub): " USERNAME
echo
read -p "Repo name: " REPO
echo
read -p "Tag name: " TAG_NAME
echo
read -p "Release name: " RELEASE_NAME
echo
read -p "Access token: " ACCESS_TOKEN
echo
read -p "File name to save (stream name): " RELEASE_FILEN
echo
read -p "Name of the file to upload: " FILE
echo

# GitHub yayın API'si üzerinden yayını oluştur
response=$(curl -X POST -H "Authorization: token $ACCESS_TOKEN" -d '{"tag_name": "'$TAG_NAME'", "name": "'$RELEASE_NAME'", "draft": false, "prerelease": false}' "https://api.github.com/repos/$USERNAME/$REPO/releases")

# JSON çıktısından tarayıcı ve indirme URL'sini al
browser_download_url=$(echo $response | jq -r '.upload_url' | sed -e 's/{?name,label}//')
browser_download_url="${browser_download_url}?name="$RELEASE_FILEN""

# Yayın dosyasını ekle
curl -X POST -H "Authorization: token $ACCESS_TOKEN" -H "Content-Type: application/zip" --data-binary @"$FILE" "$browser_download_url"
echo "Succesfull!"

unset USERNAME REPO TAG_NAME RELEASE_NAME RELEASE_FILEN ACCESS_TOKEN FILE PASS response browser_download_url
