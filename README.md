# macOS Neovim

<img src="https://github.com/user-attachments/assets/5ad505fd-2a86-4a59-80bc-cac4b697f6d6" alt="apple-logo-transparent" width="100" height="100">  
<img src="https://github.com/user-attachments/assets/593d1812-c3d8-472e-a130-01544de09a83" alt="neovim-logo-png-transparent" width="290" height="85">

\
A macOS application for opening files in Neovim.

## Features

macOS Neovim app:
- Open the corresponding file in your Neovim instance.
- Open the default/specified file explorer at the home directory if opening the app directly.
- Exiting and closing shell automatically when opening files.

Build setup:
- Automatic custom name and logo for the macOS Neovim app.
- Support for multiple terminal emulators.

## Requirements

macOS with ```codesign``` installed, used to avoid macOS gatekeeping issues. If not installed run the following command.
```console
xcode-select --install
```

## Build

To create the application run the following command:
```console
./build.sh terminal Neovim logo.png
```
The bash script takes in three arguments:
```console
./build.sh [TerminalEmulator] [AppName] [PathToLogoImg]
```
> You can select a terminal emulator by explicitly typing the name of the emulator, please refer to the [emulator](##terminal-emulators) section.

## Terminal Emulators

List of the currently supported terminal emulators and their corresponding keywords.
- Default terminal (```terminal.app```): ```terminal```
- iTerm (```iTerm.app```): ```iterm```

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
```console
/System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister -kill -r -domain local -domain system -domain user
```

3. Remove all extended attributes from your application using the following command.
```console
xattr -rc /PathToApp/AppName.app
```

4. Forcefully re-sign the application, including all nested components, using an ad-hoc signature, with no dev, using the following command.
```console
codesign --force --deep --sign - /PathToApp/AppName.app
```

5. Use the following command to verify the code signature.
```console
codesign --verify --deep --strict /PathToApp/AppName.app
```

Done, now it should be available in the ```Open With``` menu's of all apps that have your selected extensions.
