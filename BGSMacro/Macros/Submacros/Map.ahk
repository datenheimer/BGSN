Teleporter(world) {
    Sleep 500
    Send " m "
    Sleep 500
    MouseMove(1700,1000,50)
    Sleep 1000
    Loop 5 {
    Click(1700,1000)
    Sleep 500
    }
    MouseMove(1700, 420, 50)
    Sleep 500
    Loop world {
    Click(1700, 420)
    Sleep 500
    }
    Sleep 500
    MouseMove(1280, 1300, 50)
    Sleep 500
    Click(1280, 1300)
    }
