@echo off
:: GitHub depo yayını yükleyicisi - GitHub repository release uploader
:: By YZBruh

:: Logcat temizliği - Clear logcat
cls
:: Curl uyarısı - Curl warning
echo "THIS SCRIPT WILL ONLY WORK IF YOU HAVE CURL INSTALLED!!!"

:: Bilgileri al - Get info's
set /p USERNAME="Username (GitHub): "
set /p REPO="Repo name: "
set /p TAG_NAME="Tag name: "
set /p RELEASE_NAME="Release name: "
set /p ACCESS_TOKEN="Access token: "
set /p RELEASE_FILEN="File name to save (stream name): "
set /p FILE="Name of the file to upload: "

:: GitHub Release API'si üzerinden yayını oluştur
curl -s -H "Authorization: token %ACCESS_TOKEN%" -d "{""tag_name"": ""%TAG_NAME%"", ""name"": ""%RELEASE_NAME%"", ""draft"": false, ""prerelease"": false}" "https://api.github.com/repos/%USERNAME%/%REPO%/releases"

:: Yayın dosyasını eklemek için
curl -s -H "Authorization: token %ACCESS_TOKEN%" -H "Content-Type: application/zip" --data-binary @%FILE% "https://uploads.github.com/repos/%USERNAME%/%REPO%/releases/%TAG_NAME%/assets?name=%RELEASE_FILEN%"
