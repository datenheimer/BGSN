#Include ../Macros/Bubbler.ahk
class Egghatcher {
    __New() {
        this.name := "Hatch Eggs"
        this.count := 0     
        this.state := false     
        this.customParams := Map(
            "speed", Map("type", "range", "min", 1, "max", 1000, "value", 50),
            "test", Map("type", "boolean", "value", true)
        )
    }

    run() {
        if !this.state
            return
        Bubbler(this.customParams["speed"]["value"])
        this.count += 1
        ToolTip "Bubblegum: " this.customParams["speed"]["value"]
        Sleep this.customParams["speed"]["value"]
        ToolTip
    }

    SetConfig(params) {
        if params.Has("toggle")
            this.state := params["toggle"]
        if params.Has("count")
            this.count := params["count"]
        if params.Has("customParams")
            this.customParams := params["customParams"]
    }

    getState() {
        return this.state
    }

    getName() {
        return this.name
    }

    getCount() {
        return this.count
    }

    setState(state) {
        this.state := state
    }

    getCustomParams() {
        return this.customParams 
    }

   setCustomParam(name, value) {
        if this.customParams.Has(name) {
            this.customParams[name]["value"] := value
        }
    }


}