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

; ;; popular hotkeys with hyper
; ~Capslock & c:: Send ^{c}
; ~Capslock & v:: Send ^{v}

;; vim navigation with hyper
#^h:: Send {Left}
#^l:: Send {Right}
#^k:: Send {Up}
#^j:: Send {Down}

~Capslock & j:: Send, (
Return

~Capslock & k:: Send, )
Return

~Capslock & l:: Send, "
Return

~Capslock & i:: Send, {|}
Return

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

; ; Define a hotkey to open or switch to Visual Studio Code
; ~Capslock & v::
; Run, "C:\Users\Me\AppData\Local\Programs\Microsoft VS Code\Code.exe";
; Return

~CapsLock & v::
ManageApp("Code.exe", "C:\Users\Me\AppData\Local\Programs\Microsoft VS Code\Code.exe")
return

~CapsLock & f::
ManageApp("firefox.exe", "C:\Program Files\Mozilla Firefox\firefox.exe")
return

~CapsLock & g::
ManageApp("chrome.exe", "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe")
return

^!r::
    ToolTip, PROgramming keys reloading
    Sleep 1000 
    Reload 
    Tooltip

; Suspend and unsuspend hotkeys
!<:: Suspend 

ManageApp(app_exe, app_path) {

    WinGet, win_id, list, ahk_exe %app_exe%

    ; If the app is not running, start it
    If (win_id = "") 
    {
        Run, %app_path%
        return
    }


    WinGet, ActiveProcess, ProcessName, A
    WinGet, OpenWindowsAmount, Count, ahk_exe %ActiveProcess%
    WinGetActiveTitle, active_app
    WinGet, activePath, ProcessPath, % "ahk_id" winActive("A")	
    ToolTip, active_app: %active_app% // app_exe: %app_exe% // OpenWindowsAmount: %OpenWindowsAmount% // activePath: %activePath%
 
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
