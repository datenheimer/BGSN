#Include ./mouse.ahk
screenW := A_ScreenWidth
screenH := A_ScreenHeight
Teleporter(world) {
    Sleep 1000
    Send "m"
    Sleep 500

    Loop 6 {
        Send "{WheelDown}"
        Sleep 100
    }

    Loop world + 1 {
        Send "{WheelUp}"
        Sleep 100
    }

    MouseMove(Round(1150 * (screenW / 2160)), Round(1200 * (screenH / 1440)), 50)
    Sleep 500
    Click(Round(1150 * (screenW / 2160)), Round(1200 * (screenH / 1440)))
    Sleep 500
    Click
    Sleep 500
}