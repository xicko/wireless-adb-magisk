while IFS='=' read -r key value || [ -n "$key" ]; do
    case "$key" in
        id)          ID="$value" ;;
        name)        NAME="$value" ;;
        version)     VERSION="$value" ;;
        versionCode) VERSION_CODE="$value" ;;
        author)      AUTHOR="$value" ;;
        description) DESCRIPTION="$value" ;;
    esac
done < module.prop

zip -r9 ./wireless-adb-$VERSION-$VERSION_CODE.zip . -x "*.DS_Store" -x "__MACOSX*" -x "*.git*" -x "zip.sh" -x ".gitignore" -x "*.zip"