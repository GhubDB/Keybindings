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

; ;; vim navigation with hyper
; ~Capslock & h:: Send {Left}
; ~Capslock & l:: Send {Right}
; ~Capslock & k:: Send {Up}
; ~Capslock & j:: Send {Down}

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
        SwitchToNextWindow()
        Return
    }

    ; Else, switch the window of the app we want to active
    WinActivate ahk_exe %app_exe%
}

SwitchToNextWindow() {
    WinGetClass, ActiveClass, A
    WinSet, Bottom,, A
    WinActivate, ahk_class %ActiveClass%
    Return
}
