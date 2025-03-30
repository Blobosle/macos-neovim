#!/usr/bin/env bash

if [ "$#" -lt 1 ]; then
    echo "Usage: $0 {iterm|terminal} [AppName] [logo.png]"
    exit 1
fi

TERMINAL_TYPE="$1"

if [ "$#" -ge 2 ]; then
    APP_BASENAME="$2"
else
    APP_BASENAME="Neovim"
fi

case "$APP_BASENAME" in
    *.app)
        APP_NAME="$APP_BASENAME"
        ;;
    *)
        APP_NAME="${APP_BASENAME}.app"
        ;;
esac

if [ "$#" -ge 3 ]; then
    LOGO_PATH="$3"
else
    LOGO_PATH="logo.png"
fi

case "$TERMINAL_TYPE" in
    iterm)
        SCRIPT_FILE="src/iterm.applescript"
        ;;
    terminal)
        SCRIPT_FILE="src/terminal.applescript"
        ;;
    *)
        echo -e "\033[0;31mError: Invalid terminal type. Use 'iterm' or 'terminal'.\033[0m"
        exit 1
        ;;
esac

case "$LOGO_PATH" in
    *.png)
        ;;
    *)
        echo -e "\033[0;31mError: Logo file must be a PNG.\033[0m"
        exit 1
        ;;
esac

rm -rf "$APP_NAME"

if osacompile -o "$APP_NAME" "$SCRIPT_FILE"; then
    echo "Build complete."

    if [ -f "$LOGO_PATH" ]; then
        echo "Found $LOGO_PATH. Converting to app icon..."

        sips --resampleHeightWidth 1024 1024 "$LOGO_PATH" --out logo_tmp.png
        mv logo_tmp.png "$LOGO_PATH"

        mkdir -p logo.iconset
        sips -z 16 16     "$LOGO_PATH" --out logo.iconset/icon_16x16.png
        sips -z 32 32     "$LOGO_PATH" --out logo.iconset/icon_16x16@2x.png
        sips -z 32 32     "$LOGO_PATH" --out logo.iconset/icon_32x32.png
        sips -z 64 64     "$LOGO_PATH" --out logo.iconset/icon_32x32@2x.png
        sips -z 128 128   "$LOGO_PATH" --out logo.iconset/icon_128x128.png
        sips -z 256 256   "$LOGO_PATH" --out logo.iconset/icon_128x128@2x.png
        sips -z 256 256   "$LOGO_PATH" --out logo.iconset/icon_256x256.png
        sips -z 512 512   "$LOGO_PATH" --out logo.iconset/icon_256x256@2x.png
        sips -z 512 512   "$LOGO_PATH" --out logo.iconset/icon_512x512.png
        sips -z 1024 1024 "$LOGO_PATH" --out logo.iconset/icon_512x512@2x.png

        iconutil -c icns logo.iconset
        if [ -f "logo.icns" ]; then
            echo "Icon conversion successful."
            mkdir -p "$APP_NAME/Contents/Resources"
            cp logo.icns "$APP_NAME/Contents/Resources/"


            /usr/libexec/PlistBuddy -c "Set :CFBundleIconFile logo.icns" "$APP_NAME/Contents/Info.plist"
        else
            echo -e "\033[0;31mFailed to create logo.icns from $LOGO_PATH.\033[0m"
        fi

        rm -rf logo.iconset logo.icns
    else
        echo "$LOGO_PATH not found, skipping icon conversion."
    fi

    read -r -p "Do you want to move the app to /Applications folder? [Y/N] " answer
    if [[ "$answer" =~ ^[Yy] ]]; then
        echo "Moving the app to /Applications folder..."
        if mv "$APP_NAME" "/Applications/"; then
            echo "App moved to /Applications."
            APP_PATH="/Applications/$APP_NAME"
        else
            echo -e "\033[0;31mFailed to move the app into /Applications folder. Using local copy.\033[0m"
            APP_PATH="./$APP_NAME"
        fi
    else
        echo "App not moved. Using local copy."
        APP_PATH="./$APP_NAME"
    fi

    echo "Removing extended attributes from $APP_PATH..."
    xattr -rc "$APP_PATH"
    echo "Codesigning $APP_PATH..."
    codesign --force --deep --sign - "$APP_PATH"
    echo "Verifying codesign on $APP_PATH..."
    codesign --verify --deep --strict "$APP_PATH"
    echo -e "\033[0;34mThe created app is located at: $APP_PATH\033[0m"
    echo -e "\033[0;34mMacOS Neovim set up successfully!\033[0m"
else
    echo -e "\033[0;31mBuild failed. Please check that the script file exists and try again.\033[0m"
    exit 1
fi
