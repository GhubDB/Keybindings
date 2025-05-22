@echo off
setlocal

:: Define the source and destination file paths
set "sourcePath=C:\projects\tools\Keybindings\vsvim\.vsvimrc"
set "destinationPath=C:\Users\taadimo2\.vsvimrc"

:: Check if source file exists
if not exist "%sourcePath%" (
    echo Source file does not exist: %sourcePath%
    exit /b 1
)

:: Copy the contents of the source file to the destination file
copy /Y "%sourcePath%" "%destinationPath%"
if errorlevel 1 (
    echo Failed to copy content to %destinationPath%
    exit /b 1
) else (
    echo Successfully overwritten the contents of %destinationPath% with those from %sourcePath%
)

endlocal
