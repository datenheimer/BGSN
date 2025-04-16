class Bubblegum {
    __New() {
        this.count := 0
        this.state := true
    }

    run() {
        if !this.state
            return
        this.count += 1
        Bubbler()
        ToolTip "Bubblegum: " this.count
        Sleep 500
        ToolTip
    }

    SetConfig(params) {
        if params.Has("toggle")
            this.state := params["toggle"]
        if params.Has("count")
            this.count := params["count"]
    }

    getState() {
        return this.state
    }

    toggleState() {
        this.state := !this.state
    }
}
