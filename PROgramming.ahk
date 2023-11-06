GroupAdd, CodeEditors, ahk_class Qt5152QWindowIcon
GroupAdd, CodeEditors, ahk_class Chrome_WidgetWin_1
GroupAdd, CodeEditors, ahk_class SunAwtFrame
SetTitleMatchMode, 2
GroupAdd, CodeEditors, Microsoft Visual Studio
#IfWinActive, ahk_group CodeEditors

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