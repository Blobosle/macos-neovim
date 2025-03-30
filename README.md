# MacOS Neovim

A MacOS application for opening files in Neovim.

## Features

The application will:
- Open the corresponding file in your Neovim instance
- Open the default/specified file explorer at the home directory if opening the app directly
- Exiting and closing shell automatically when opening files

## Build

To create the application run the following command:
```
./build.sh terminal Neovim logo.png
```
The bash script takes in three arguments:
```
./build.sh [TERMINAL EMULATOR PREFERENCE] [NAME OF APP] [PATH TO LOGO IMAGE]
```
> You can select a terminal emulator by explicitly typing the name of the emulator, please refer to emulator section.

