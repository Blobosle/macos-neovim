on run {input, parameters}
    set nvimCommand to "/usr/local/bin/nvim -p "

    if input is {} then
        set filepaths to "."
    else
        set filepaths to ""
        repeat with currentFile in input
            set filepaths to filepaths & quoted form of POSIX path of currentFile & " "
        end repeat
    end if

    tell application "Terminal"
        reopen
        activate

        set newWindow to create window with default profile

        tell newWindow
            activate
        end tell

        tell current session of newWindow
            if input is {} then
                write text nvimCommand & filepaths
            else
                write text nvimCommand & filepaths & "; exit"
            end if
        end tell
    end tell
end run

