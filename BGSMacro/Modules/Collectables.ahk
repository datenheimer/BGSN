#Include ../Macros/Bubbler.ahk
class Collectables {
    __New() {
        this.name := "Collectables"
        this.count := 0     
        this.state := false     
        this.customParams := Map(
            "speed", Map("type", "range", "min", 1, "max", 1000, "value", 50),
            "test", Map("type", "boolean", "value", true),
            "goob", Map("type", "boolean", "value", true),
            "jackblack", Map("type", "dropdown", "options", ["Chicken", "Jockey"], "value", "Chicken"),
            "flavor", Map("type", "dropdown", "options", ["Strawberry", "Blueberry", "Mint", "Grape", "Orange"], "value", "Strawberry")
        )
    }

    run() {
        if !this.state
            return
        ToolTip "Bubblegum: " this.customParams["flavor"]["value"]
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

    getName() => this.name
    getState() => this.state
    setState(state) => this.state := state
    getCount() => this.count
    getCustomParams() => this.customParams
    setCustomParam(name, val) => this.customParams[name]["value"] := val
    setCount(count) => this.count := count

}