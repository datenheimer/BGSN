class Bubblegum {
    ; Define the variables
    toggle := false
    count := 0
    isRunning := false  ; Flag to track if macro is executing

    ; Constructor to initialize state
    __New(toggle := false, count := 0) {
        this.toggle := toggle
        this.count := count
    }

    ; Method to process the macro
    processMacro() {
        ; Check if another macro is currently running
        if (this.isRunning) {
            MsgBox("Macro is already running, please wait.")
            return
        }

        ; Set the flag to indicate that macro is running
        this.isRunning := true
        ; Execute macro logic based on toggle and count
        MsgBox("Processing Bubblegum Macro..." "`nToggle: " this.toggle "`nCount: " this.count)

        ; For example, we could delay the operation
        Sleep(2000) ; Simulate a 2 second macro operation

        ; After the macro is finished
        MsgBox("Bubblegum Macro finished.")
        this.isRunning := false  ; Reset the flag
    }

    ; Method to set toggle and count values dynamically
    updateValues(toggle, count) {
        this.toggle := toggle
        this.count := count
    }
}