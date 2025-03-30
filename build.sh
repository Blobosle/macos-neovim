#!/usr/bin/env bash

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 {iterm|terminal}"
    exit 1
fi

case "$1" in
    iterm)
        SCRIPT_FILE="src/iterm.applescript"
        APP_NAME="Neovim-iterm.app"
        ;;
    terminal)
        SCRIPT_FILE="src/terminal.applescript"
        APP_NAME="Neovim-terminal.app"
        ;;
    *)
        echo -e "\033[0;31mBuild failed. Please specify a valid target terminal emulator app for opening your Neovim instance."
        exit 1
        ;;
esac

rm -rf "$APP_NAME"
if osacompile -o "$APP_NAME" "$SCRIPT_FILE"; then
    echo "Build complete."

    read -r -p "Do you want to move the app to /Applications folder? [Y/N] " answer
    case "$answer" in
        [Yy]* )
            echo "Moving the app to /Applications folder..."
            if mv "$APP_NAME" "/Applications/"; then
                echo "App moved to /Applications."
                echo -e "\033[0;34mMacOS Neovim set up successfully!\033[0m"
            else
                echo -e "\033[0;31mFailed to move the app into /Applications folder.\033[0m"
                exit 1
            fi
            ;;
        [Nn]* )
            echo "App not moved. You can move it manually later."
            echo "Run ./$APP_NAME on your shell to run the application."
            echo -e "\033[0;34mMacOS Neovim set up successfully!\033[0m"
            ;;
        * )
            echo "Invalid input. App not moved."
            ;;
    esac
else
    echo -e "\033[0;31mBuild failed. Please check that the script file exists and try again."
    exit 1
fi
