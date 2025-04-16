#Requires AutoHotkey v2.0

SetTimer(ShowMousePos, 100)

ShowMousePos() {
    CoordMode("Mouse", "Screen")  ; Use screen coordinates
    MouseGetPos(&x, &y)
    ToolTip("Mouse Position: " x ", " y)
}

Esc::ExitApp