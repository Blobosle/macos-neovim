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

    tell application "Terminal"
        reopen
        activate
        if fileList is {} then
            do script nvimCommand & filepaths
        else
            do script nvimCommand & filepaths & "; exit"
        end if
    end tell
end processFiles

