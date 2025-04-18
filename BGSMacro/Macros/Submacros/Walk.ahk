Walker(steps, d) {
    i := 0
    while i < steps
    {
        Send "{" d " down}"
        sleep 100
        Send "{" d " up}"
        i++
        }
    }
; Move mouse and click
; MouseMove, 100, 100
; Click

