#!/bin/sh

while IFS='=' read -r key value || [ -n "$key" ]; do
    case "$key" in
        version)     VERSION="$value" ;;
        versionCode) VERSION_CODE="$value" ;;
    esac
done < module.prop

zip -r9 ./wireless-adb-"$VERSION"-"$VERSION_CODE".zip . -x "*.DS_Store" -x "__MACOSX*" -x "*.git*" -x "zip.sh" -x ".gitignore" -x "*.zip" -x "assets/*"