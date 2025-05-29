#NoEnv ; recommended for performance and compatibility with future autohotkey releases.
#UseHook
#InstallKeybdHook
#SingleInstance force
SendMode Input
SetCapsLockState, AlwaysOff ; Ensure CapsLock is always off initially

GroupAdd, CodeEditors, ahk_class Qt5152QWindowIcon
GroupAdd, CodeEditors, ahk_class Chrome_WidgetWin_1
GroupAdd, CodeEditors, ahk_class SunAwtFrame
SetTitleMatchMode, 2
GroupAdd, CodeEditors, Microsoft Visual Studio

global compName := ComObjCreate("WScript.Network").ComputerName
; MsgBox % "Your computer's name is : " . compName
global pathKeys := {}

ReadFilepaths()

#IfWinActive, ahk_group CodeEditors

    ; ###########################################################################
    ; Key Remappings
    ; ###########################################################################

    ; Remap ö to {
    ö::Send, {{}

    ; Remap Shift+ö to AltGr+ä
    +ö::Send, {}}

    ; Remap ü to AltGr+ü
    ü::Send, [

    ; Remap Shift+ü to AltGr+!
    +ü::Send, ]

    ; Remap ä to Shift+^
    ä::Send, {``}{Space}

    ; Remap Shift+ä to ^
    +ä::Send, {^}{Space}

#IfWinActive

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

~Capslock & j:: Send, (
Return

~Capslock & k:: Send, )
Return

~Capslock & l:: Send, "
Return

~Capslock & i:: Send, {|}
Return

~Capslock & u:: Send, @
Return

~Capslock & m:: Send, $
Return

~Capslock & left:: Send, {LWin down}{Shift down}{Left down}{Left up}{Shift up}{LWin up}
Return

~Capslock & right:: Send, {LWin down}{Shift down}{Right down}{Right up}{Shift up}{LWin up}
Return

~Capslock & up:: Send, {LWin down}{Up down}{Up up}{LWin up}
Return

~Capslock & down:: Send, {LWin down}{Down down}{Down up}{LWin up}
Return

; Tab through windows forwards and backwards
~CapsLock & .::
    SwitchWindowsDirectionally(1)
return

~CapsLock & ,::
    SwitchWindowsDirectionally(-1)
return

; ;; vim navigation with hyper
~CapsLock & ä:: Send {Up}
~CapsLock & ö:: Send {Down}

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
        ; SwitchToNextWindow()
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

; ###########################################################################
; Text expansions
; ###########################################################################

; Git commands
::gp::
    insertText("git pull")
Return

::gprb::
    insertText("git pull --rebase=true")
Return

::ga::
    insertText("git add .")
Return

::gc::
    Send, git commit -m ""
    Send, {Left}
Return

::gac::
    Send, git commit -am ""
    Send, {Left}
Return

::gca::
    insertText("git add . && git commit --amend --no-edit")
Return

::gcane::
    insertText("git commit --amend")
Return

::gpu::
    insertText("git push")
Return

::gs::
    insertText("git status")
Return

::gb::
    insertText("git branch")
Return

::gbr::
    insertText("git branch -r")
Return

::gl::
    insertText("git log")
Return

::gcb::
    insertText("git checkout -b ")
Return

::gco::
    insertText("git checkout ")
Return

::gld::
    insertText("git log --graph --oneline --decorate")
Return

::gst::
    insertText("git stash")
Return

; Add "name"
::gstn::
    insertText("git stash save ")
Return

::gsta::
    insertText("git stash apply 0")
Return

::gstp::
    insertText("git stash pop")
Return

::gstl::
    insertText("git stash list")
Return

::grsth::
    insertText("git reset --hard")
Return

::gdir::
    insertText("cd C:\GIT\AVA\AVEL_Release")
Return

::pdir::
    insertText("cd C:\projects")
Return

; Docker
::dup::
    insertText("docker compose up -d")
Return

::dbup::
    insertText("docker compose up -d --build")
Return

::ddown::
    insertText("docker compose down")
Return

::docker build .::
    insertText("docker build .")
Return

; NPM
::npmdefault::
    insertText("npm config set registry https://registry.npmjs.org/")
Return

::npmartifactory::
    insertText("npm config set registry https://artifactory.swisscom.com/artifactory/api/npm/npm-remote")
Return

::npmsetproxy::
    insertText("npm config set proxy http://aproxy.corproot.net:8080/ && npm config set https-proxy https://aproxy.corproot.net:8080/")
Return

::npmunsetproxy::
    insertText("npm config delete proxy && npm config delete https-proxy")
Return

::relv::
    insertText("source C:\Users\taadimo2\.vsvimrc")
Return

; Terminal
::checkpath::
    insertText("echo %PATH%")
Return

; DevExtreme
::dadd::
    insertText("npx devextreme add view")
Return

; General
; Opens explorer at current terminal location
::oex::Start-Process explorer -ArgumentList (Get-Location)

; VsCode
::c.::code .
::cr.::code -r .

!l::
    Send, console.log("")
    Send, {Left}
    Send, {Left}
Return

insertText(txt)
{
    clipboardContent := RTrim(Clipboard) ;save clipboard to variable
    Clipboard := txt
    ClipWait
    sleep, 150
    SendInput ^v
    sleep, 400
    Clipboard := clipboardContent
    Return
}

; ###########################################################################
; General Hotkeys
; ###########################################################################

; Reload hotkey file (Useful after a change)
^!r::
    ToolTip, PROgramming keys reloading
    Sleep 1000
    Reload
    Tooltip

; Suspend and unsuspend hotkeys
!<:: Suspend