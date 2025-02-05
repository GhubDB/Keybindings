#NoEnv ; recommended for performance and compatibility with future autohotkey releases.
#UseHook
#InstallKeybdHook
#SingleInstance force
SendMode Input
SetCapsLockState, AlwaysOff ; Ensure CapsLock is always off initially

global compName := ComObjCreate("WScript.Network").ComputerName
; MsgBox % "Your computer's name is : " . compName
global pathKeys := {}

ReadFilepaths()

; ###########################################################################
; App shortcuts

; You can find the filepath for windows store apps by entering
; shell:AppsFolder into the explorer address bar
; How to find the teams executable:
; %localappdata%\Microsoft\Teams\Current\Teams.exe
; ###########################################################################

; Read filepaths from ini file and generate hotkeys
ReadFilepaths() {
    FileRead, fileData, %compName%.ini

    Loop, Parse, fileData, `n, `r
    {
        StringSplit, lineData, A_LoopField, `,
        if (lineData0 == 2) {
            Hotkey, ~CapsLock & %lineData1%, CallManageApp
            pathKeys[lineData1] := lineData2
        }
    }
}

CallManageApp:
    ManageApp()
return

; Disable the windows shortcut before using this hyper key
; Run this command in an elevated CMD terminal:
; REG ADD HKCU\Software\Classes\ms-officeapp\Shell\Open\Command /t REG_SZ /d rundll32
; After this command is completed, the Office app shortcut will be disabled and the Hyper key will not open it again.
;; note: must use tidle prefix to fire hotkey once it is pressed
;; not until the hotkey is released
~Capslock::
    ;; must use downtemp to emulate hyper key, you cannot use down in this case
    ;; according to https://autohotkey.com/docs/commands/Send.htm,
    ;; downtemp is as same as down except for ctrl/alt/shift/win keys
    ;; in those cases, downtemp tells subsequent sends that the key is not permanently down, and may be
    ;; released whenever a keystroke calls for it.
    ;; for example, Send {Ctrl Downtemp} followed later by Send {Left} would produce a normal {Left}
    ;; keystroke, not a Ctrl{Left} keystroke
    Send {Ctrl DownTemp}{Shift DownTemp}{Alt DownTemp} ;;{LWin DownTemp}
    KeyWait, Capslock
    Send {Ctrl Up}{Shift Up}{Alt Up} ;;{LWin Up}
    if (A_PriorKey = "Capslock") {
        Send {Esc}
    }
return

ManageApp() {
    ; Get the last key from the pressed hotkey
    keyName := Trim(SubStr(A_ThisHotkey, -1))
    app_path := pathKeys[keyName]
    path_chunks := StrSplit(app_path, "\")
    app_exe := path_chunks[path_chunks.Length()]

    ; Set ErrorLevel to 0 if the application is not open
    Process, Exist, %app_exe%

    ; If the app is not running, start it
    If (ErrorLevel = 0)
    {
        Run, %app_path%
        return
    }

    WinGet, ActiveProcess, ProcessName, A
    WinGet, OpenWindowsAmount, Count, ahk_exe %ActiveProcess%
    WinGet, activePath, ProcessPath, % "ahk_id" winActive("A")

    ; If the app we are looking for is already active,
    ; and there is more than one window open, switch to the next window
    If (activePath = app_path && OpenWindowsAmount > 1)
    {
        SwitchWindowsDirectionally(1)
        Return
    }

    ; Else, switch the window of the app we want to active
    WinActivate ahk_exe %app_exe%
}

SwitchWindowsDirectionally(Direction)
{
    static total, hWnds, last := ""

    a := WinExist("A")
    WinGetClass wClass
    WinGet exe, ProcessName

    last := exe
    hWnds := []
    DetectHiddenWindows Off
    WinGet wList, List, % "ahk_exe" exe " ahk_class" wClass
    loop % wList {
        hWnd := wList%A_Index%
        hWnds.Push(hWnd)
    }
    total := hWnds.Count()

    for i,hWnd in hWnds {
        if (a = hWnd)
            break
    }

    i += Direction
    i := i > total ? 1 : i = 0 ? total : i

    WinActivate % "ahk_id" hWnds[i]
}

; Tab through windows forwards and backwards
~CapsLock & .::
    SwitchWindowsDirectionally(1)
return

~CapsLock & ,::
    SwitchWindowsDirectionally(-1)
return

; Reload hotkey file with Ctrl + Alt + r (Useful after a change)
^!r::
    ToolTip, Reloading macro
    Sleep 1000
    Reload
    Tooltip

; Suspend and unsuspend hotkeys with Alt + <
!<:: Suspend