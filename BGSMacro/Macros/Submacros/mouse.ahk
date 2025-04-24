#Requires AutoHotkey v2.0
    screenW := A_ScreenWidth
    screenH := A_ScreenHeight
ShowMousePos() {
    CoordMode("Mouse", "Screen")  ; Use screen coordinates
    MouseGetPos(&x, &y)
    ToolTip("Mouse Position: " x ", " y)
}
;Loop {
;    ShowMousePos()
;}


