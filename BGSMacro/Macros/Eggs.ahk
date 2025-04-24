#Requires AutoHotkey v2.0
#Include ./Submacros/Map.ahk
#Include ./Submacros/Walk.ahk
    screenW := A_ScreenWidth
    screenH := A_ScreenHeight
eggs := ["Common", "Void", "Hell", "Nightmare", "Rainbow", "Infinity", "Pastel", "Bunny", "Throwback Egg"]

EggHatcher(egg, hour) {
    found := false
    Sleep 2000
    Send("{Escape}")
    Sleep 500
    Send(" r ")
    Sleep 500
    Send("{Enter}")
    Sleep 4000

    Teleporter(4)
    Sleep 500
    MsgBox("SHUT UP THIS IS WORKING I PWOMISE")
    MouseMove(Round(1150 * (screenW / 2160)), Round(1300 * (screenH / 1440)), 50)
    Sleep 500
    Click(Round(1150 * (screenW / 2160)), Round(1300 * (screenH / 1440)))
    Click()  ; Click at current position

    Sleep 2000
    Walker(3, "a")
    Sleep 500
    Walker(3, "w")
    Sleep 1000

    ; Optional: Color search logic (commented out for now)
    /*
    while !found {
        if !PixelSearch(&OutputX, &OutputY, 600, 100, 840, 540, 0xdd383d, 50, "RGB") {
            MsgBox("Color not found")
            Send("{Right 3}")
        } else {
            MsgBox("Color found at " OutputX ", " OutputY)
            found := true
        }
    }
    */

    ; Walk if egg type is matched
    Loop eggs.Length {
        if egg = eggs[A_Index] {
            Sleep 1500
            Walker(5, "d")
            break
        }
    }
}

; Example usage
Sleep 1000
EggHatcher("Common", 1)

; Pause macro
F8::Pause
