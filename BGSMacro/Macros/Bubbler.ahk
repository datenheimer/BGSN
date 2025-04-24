#Requires AutoHotkey v2.0
#Include ./Submacros/Map.ahk
#Include ./Submacros/Walk.ahk

Bubbler(i) {
    j := 0
    Sleep 2000
    Send('{Escape}')
    Sleep 500
    Send " r "
    Sleep 500
    Send('{Enter}')
    Sleep 4000

    Teleporter(3)
    Sleep 4000

    walker(4, "d")
    sleep 500
    walker(8, "s")

    ; Get current screen resolution
    screenW := A_ScreenWidth
    screenH := A_ScreenHeight

    ; Original hardcoded position: Click(1280, 600)
    ; Scale based on 2560x1440 resolution
    scaledX := Round(1280 * (screenW / 2560))
    scaledY := Round(600 * (screenH / 1440))

    while i > j {
        Loop 100 {
            Click(scaledX, scaledY)
            Sleep 500
        }
        j++
    }
}
sleep 1000
F8::Pause
Bubbler(1)