#Include ./Submacros/Map.ahk
#Include ./Submacros/Walk.ahk
Bubbler(i) {
    j := 0
    sleep 2000
    Send('{Escape}')
    Sleep 500
    Send " r "
    Sleep 500
    Send('{Enter}')

    Sleep 4000

    Teleporter(3)

    Sleep 1000

    walker(5, "d")
    walker(8, "s")

   while i > j 
    Loop 100 {
       Click(1280,600)
        Sleep 100
    }
    }
    sleep 1000
    F8::Pause