#Requires AutoHotkey v2.0

ShowMousePos() {
    CoordMode("Mouse", "Screen")  ; Use screen coordinates
    MouseGetPos(&x, &y)
    ToolTip("Mouse Position: " x ", " y)
}