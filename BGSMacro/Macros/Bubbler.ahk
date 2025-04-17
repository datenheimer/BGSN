#Include ./Submacros/Map.ahk
#Include ./Walk.ahk
Bubbler(i) {
    j := 0

    Sleep 500

    Teleporter(3)

    Sleep 1000

    walker(6, "a")
    walker(8, "w")

   while i > j 
    Loop 100 {
       Click(1280,600)
        Sleep 500
    }
    }
    sleep 1000
    bubbler(1)
    F8::Pause