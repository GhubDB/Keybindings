# README

Enhance your productivity with custom hotkeys to manage your applications efficiently.

## Features

- **Start Applications:** Launch your applications using hotkeys.
- **Focus Applications:** Bring already running applications to the foreground with a keypress.
- **Window Navigation:** Easily switch between multiple windows of the same application.

## How to Use

Follow these steps to set up and use the script:

1. **Create Configuration File:**
   - Name the `.ini` file after your computer's hostname.
   - To display your computer's name, uncomment the following line in the script:
     ```ahk
     ; MsgBox % "Your computer's name is: " . compName
     ```
     Example filename: `U12345.ini`

2. **Define Hotkeys:**
   - In the `.ini` file, specify the hotkeys and paths for your applications.
     Format: `<hotkey>,<application-filepath>`
     Example: `f,C:\Program Files\Mozilla Firefox\firefox.exe`

3. **Install AutoHotkey:**
   - Download and install Autohotkey v1 from their [official website](https://www.autohotkey.com/).

4. **Launch Applications:**
   - Start the script using Autohotkey.
   - Press `Capslock` + your hotkey to start the corresponding application.

5. **Focus Running Application:**
   - Hit the defined hotkey to pull the application window to the front.

6. **Navigate Between Windows:**
   - `Capslock` + `,` moves to the previous window.
   - `Capslock` + `.` moves to the next window.

7. **Setup Autostart:**
   - Press `Win` + `R`, enter `shell:startup`, and press `Enter`.
   - Add a shortcut to the script in this folder for automatic startup execution.