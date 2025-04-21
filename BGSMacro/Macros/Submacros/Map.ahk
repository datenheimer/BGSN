#Include ./mouse.ahk
Teleporter(world) {
    Sleep 1000
    Send "m"
    Sleep 500
    Loop world + 1 {
        Send "{WheelUp}"
        Sleep 1000
    }
}