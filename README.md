# macOS Neovim

<img width="450" height="400" alt="macos-neovim" src="https://github.com/user-attachments/assets/9f07328f-e64e-40e5-bbb0-4f7046ddb287" />

\
A macOS application for opening files in Neovim.

## Features

macOS Neovim app:
- Open a file of your choice in your Neovim instance.
- Open the default/specified file explorer at the home directory if opening the app directly.
- Exiting and closing shell automatically when opening files.

Build setup:
- Automatic custom name and logo for the macOS Neovim app.
- Support for multiple terminal emulators.

## Requirements

macOS with ```codesign``` installed, used to avoid macOS gatekeeping issues. If not installed run the following command.
```
xcode-select --install
```

## Build

To create the application run the following command:
```
./build.sh terminal Neovim logo.png
```
The bash script takes in three arguments:
```
./build.sh [TerminalEmulator] [AppName] [PathToLogoImg]
```
> You can select a terminal emulator by explicitly typing the name of the emulator, please refer to the [emulator](##terminal-emulators) section.

Running ```./build.sh``` with only the terminal emulator specified will default the name to be ```Neovim``` and the image path to be ```./logo.png```.

## Terminal Emulators

List of the currently supported terminal emulators and their corresponding keywords.

| Terminal Emulator | App Bundle  |  Keyword  |
|-------------------|----------|--------------|
| macOS terminal  | Terminal.app | ```terminal``` |
| iTerm             | iTerm.app   | ```iterm```    |


## Common issues

### Logo not loading

Often is a refreshing issue.
Fixed by left-clickling the application and selecting ```Get Info```

## Additional options

### Adding the application to ```Open With``` menu

The app will not appear in the ```Open With``` option when left-clicking the file you want to open.

This feature may be integrated later on.

The following is a step by step guide on how to implement it as a menu option:

1. Open the ```info.plist``` file, which can be found in ```PathToApp/AppName.app/Contents/Info.plist```, and modify the tags under ```CFBundleTypeExtensions```. It should look something like this
```html
<key>CFBundleTypeExtensions</key>
<array>
    <string>*</string>
...
```

Add the file extensions of the files that you want the app to appear in their ```Open With``` menu. The following is an example for the ```.txt``` and ```.tex``` file extensions.
```html
<key>CFBundleTypeExtensions</key>
<array>
    <string>tex</string>
    <string>txt</string>
    <string>*</string>
...
```

2. Rebuild the LaunchServices database by recursively re-registering apps.
```
/System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister -kill -r -domain local -domain system -domain user
```

3. Remove all extended attributes from your application using the following command.
```
xattr -rc /PathToApp/AppName.app
```

4. Forcefully re-sign the application, including all nested components, using an ad-hoc signature, with no dev, using the following command.
```
codesign --force --deep --sign - /PathToApp/AppName.app
```

5. Use the following command to verify the code signature.
```
codesign --verify --deep --strict /PathToApp/AppName.app
```

Done, now it should be available in the ```Open With``` menu's of all apps that have your selected extensions.
