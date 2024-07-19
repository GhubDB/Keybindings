#NoEnv ; recommended for performance and compatibility with future autohotkey releases.
#UseHook
#InstallKeybdHook
#SingleInstance force
SendMode Input

GroupAdd, CodeEditors, ahk_class Qt5152QWindowIcon
GroupAdd, CodeEditors, ahk_class Chrome_WidgetWin_1
GroupAdd, CodeEditors, ahk_class SunAwtFrame
SetTitleMatchMode, 2
GroupAdd, CodeEditors, Microsoft Visual Studio
#IfWinActive, ahk_group CodeEditors

SetCapsLockState, AlwaysOff ; Ensure CapsLock is always off initially

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

; Disable the windows shortcut before using this hyper key
; Click Search on the taskbar, enter CMD, select Run as administrator to open, enter the following command and press Enter:
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

~Capslock & a:: Send ^{c}
~Capslock & s:: Send ^{v}

~Capslock & j:: Send, (
Return

~Capslock & k:: Send, )
Return

~Capslock & l:: Send, "
Return

~Capslock & i:: Send, {|}
Return

~Capslock & left:: Send, {LWin down}{Shift down}{Left down}{Left up}{Shift up}{LWin up}
Return

~Capslock & right:: Send, {LWin down}{Shift down}{Right down}{Right up}{Shift up}{LWin up}
Return

~Capslock & up:: Send, {LWin down}{Up down}{Up up}{LWin up}
Return

~Capslock & down:: Send, {LWin down}{Down down}{Down up}{LWin up}
Return

; ;; vim navigation with hyper
; ~§ & h:: Send {Left}
; ~§ & l:: Send {Right}
; ~§ & k:: Send {Up}
; ~§ & j:: Send {Down}

; App shortcuts
; You can find the filepath for windows store apps by entering 
; shell:AppsFolder into the explorer address bar

~CapsLock & v::
ManageApp("C:\Users\Me\AppData\Local\Programs\Microsoft VS Code\Code.exe")
return

~CapsLock & f::
ManageApp("C:\Program Files\Mozilla Firefox\firefox.exe")
return

~CapsLock & g::
ManageApp("C:\Program Files (x86)\Google\Chrome\Application\chrome.exe")
return

~CapsLock & m::
ManageApp("C:\Program Files (x86)\foobar2000\foobar2000.exe")
return

~CapsLock & n::
ManageApp("C:\Program Files\Neovim\bin\nvim.exe")
return

~CapsLock & r::
ManageApp("C:\Program Files\JetBrains\JetBrains Rider 2023.2.3\bin\rider64.exe")
return

~CapsLock & b::
ManageApp("C:\WinStoreApps\Audiobooked")
return

~CapsLock & p::
ManageApp("C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe")
return

~CapsLock & w::
ManageApp("C:\Windows\System32\wsl.exe")
return

; Tab through windows forwards and backwards
~CapsLock & .::
SwitchWindowsDirectionally(1)
return

~CapsLock & ,::
SwitchWindowsDirectionally(-1)
return

; Reload hotkey file (Useful after a change)
^!r::
    ToolTip, PROgramming keys reloading
    Sleep 1000 
    Reload 
    Tooltip

; Suspend and unsuspend hotkeys
!<:: Suspend 

ManageApp(app_path) {
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

    if (exe != last) {
        last := exe
        hWnds := []
        DetectHiddenWindows Off
        WinGet wList, List, % "ahk_exe" exe " ahk_class" wClass
        loop % wList {
            hWnd := wList%A_Index%
            hWnds.Push(hWnd)
        }
        total := hWnds.Count()
    }

    for i,hWnd in hWnds {
        if (a = hWnd)
            break
    }

    i += Direction
    ; i := Max(1, Min(total, i))
    i := i > total ? 1 : i = 0 ? total : i

    WinActivate % "ahk_id" hWnds[i]
}

SwitchToNextWindow() {
    WinGetClass, ActiveClass, A
    WinSet, Bottom,, A
    WinActivate, ahk_class %ActiveClass%
    Return
}

::ga::git add .

::gc::
Send, git commit -m ""
Send, {Left}
Return

::gp::git push

::gs::git status

::gb::git branch

::gl::git log

::gcb::git checkout -b

::gca::git commit --amend

::gco::git checkout 

::ns::npm run start

::nb::npm run build

::nt::npm run test

::ni::npm install
