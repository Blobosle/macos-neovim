on run
    processFiles({})
end run

on open fileList
    processFiles(fileList)
end open

on processFiles(fileList)

    set nvimCommand to "/usr/local/bin/nvim -p "


    if fileList is {} then
        set filepaths to "."
    else
        set filepaths to ""
        repeat with currentFile in fileList
            set filepaths to filepaths & quoted form of POSIX path of currentFile & " "
        end repeat
    end if

    tell application "iTerm"

        reopen
        activate


        set newWindow to create window with default profile


        tell newWindow
            activate
        end tell


        tell current session of newWindow
            if fileList is {} then

                write text nvimCommand & filepaths
            else

                write text nvimCommand & filepaths & "; exit"
            end if
        end tell
    end tell
end processFiles

