#Requires AutoHotkey v2.0

; Get the window handle by title
WinTitle := "Roblox" ; Change to your target window
if WinExist(WinTitle)
{
    hwnd := WinGetID(WinTitle)

    ; Get the client (inner) size of the window
    x := y := w := h := 0
    WinGetClientPos(&x, &y, &w, &h, hwnd)

    ; Calculate coordinates at center of client area
    coordX := x + (w // 2)
    coordY := y + (h // 2)

    MsgBox "Window: " WinTitle "`nCenter coordinates: " coordX ", " coordY
}
else
{
    MsgBox "Window not found."
}