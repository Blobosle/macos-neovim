#!/usr/bin/env bash

APP_NAME="Neovim.app"

SCRIPT_FILE="Neovim.applescript"

rm -rf "$APP_NAME"
osacompile -o "$APP_NAME" "$SCRIPT_FILE"
echo "Build complete. Run ./$APP_NAME on your shell."
