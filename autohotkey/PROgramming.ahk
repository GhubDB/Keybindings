GroupAdd, CodeEditors, ahk_class Qt5152QWindowIcon
GroupAdd, CodeEditors, ahk_class Chrome_WidgetWin_1
GroupAdd, CodeEditors, ahk_class SunAwtFrame
SetTitleMatchMode, 2
GroupAdd, CodeEditors, Microsoft Visual Studio
#IfWinActive, ahk_group CodeEditors

; CapsLock::
;     ; Send, ^+! ; Send Ctrl+Shift+Alt
;     Send {CtrlDown}{ShiftDown}{AltDown}
;     KeyWait, CapsLock ; Wait for CapsLock to be released
;     ; Send, {Esc} ; Send Escape key
;     Send {Blind}{CtrlUp}{ShiftUp}{AltUp}{Esc}
;     return

SetCapsLockState, AlwaysOff ; Ensure CapsLock is always off initially
*CapsLock::
    Send {CtrlDown}{ShiftDown}{AltDown}
    cDown := A_TickCount
Return

*CapsLock up::
    If ((A_TickCount-cDown)<400)  ; Modify press time as needed (milliseconds)
        Send {Blind}{CtrlUp}{ShiftUp}{AltUp}{Esc}
    Else
        Send {Blind}{CtrlUp}{ShiftUp}{AltUp}
Return

^+!j:: Send, (
Return

^+!k:: Send, )
Return

^+!l:: Send, "
Return

^!r::
    ToolTip, PROgramming keys reloading
    Sleep 1000 
    Reload 
    Tooltip

; Suspend and unsuspend hotkeys
!<:: Suspend 

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

; Define a hotkey to open or switch to Visual Studio Code
^+!v::
Run, "C:\Users\Me\AppData\Local\Programs\Microsoft VS Code\Code.exe";


; SetCapsLockState, AlwaysOff ; Ensure CapsLock is always off initially
