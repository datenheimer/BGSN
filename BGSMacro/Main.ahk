#Requires AutoHotkey v2.0
#SingleInstance force
#Include <WebView2/WebView2>
#Include <JSON>
#Include <_JXON>

importModules()
#Include ./loader.ahk

IsString(value) {
    return (Type(value) == "string")
}

main := Gui()
main.Icon := A_ScriptDir "./sofar.ico"
main.OnEvent("Close", (*) => ExitApp()) 
main.Show(Format("w{} h{}", A_ScreenWidth * 0.6, A_ScreenHeight * 0.6)) 

wvc := WebView2.CreateControllerAsync(main.Hwnd).Await() 
wv := wvc.CoreWebView2

global MacroMap := Map()
global manager := MacroManager()

for macroFile in GetModuleClassNames(A_ScriptDir "\Modules") {
    instance := %macroFile%()
    MacroMap[instance.getName()] := instance
    manager.addMacro(instance)
}

wv.add_NavigationCompleted(WebView2.Handler(NavigationCompletedHandler))
wv.add_WebMessageReceived(WebView2.Handler(WebMessageReceivedEventHandler))

wv.Navigate("file:///" A_ScriptDir "\HTML\mainpage.html")
wv.OpenDevToolsWindow()

NavigationCompletedHandler(handler, sender, args) {
    for key, macro in MacroMap {
        customParams := macro.getCustomParams()
        AddMacroToWebView(macro, customParams)
    }
}

WebMessageReceivedEventHandler(handler, ICoreWebView2, WebMessageReceivedEventArgs) {
    args := WebView2.WebMessageReceivedEventArgs(WebMessageReceivedEventArgs)
    msg := args.TryGetWebMessageAsString()
    jsonObj := jxon_load(&msg)
    action := jsonObj.Get("action")
    params := jsonObj.Get("params")
    if action == "changeParams" {
        macro := MacroMap[params.Get("name")]
        if (IsObject(macro)) {
            if params.Has("toggle")
                macro.setState(params.Get("toggle"))
            if params.Has("count")
                macro.setCount(params.Get("count"))

            if params.Has("customParams") {
                customParams := params.Get("customParams")
                for param in customParams {
                    if param.Has("name") && param.Has("value")
                        macro.setCustomParam(param["name"], param["value"])
                }
            }
            AddMacroToWebView(macro, macro.getCustomParams())
        }

    }
}

AddMacroToWebView(macro, params) {
    message := {
        action: "addMacro",
        params: {
            name: macro.GetName(), 
            toggle: macro.getState(), 
            count: macro.getCount(), 
            customParams: params 
        }
    }

    jsonMessage :=JSON.stringify(message) 
    wv.PostWebMessageAsString(jsonMessage) 
}

class MacroManager {
    __New() {
        this.macros := []
        this.isRunning := false
        this._loopRef := this.runLoop.Bind(this)
    }

    addMacro(macro) {
        this.macros.Push(macro)
    }

    toggle() {
        this.isRunning := !this.isRunning
        if this.isRunning {
            SetTimer this._loopRef, 100
        } else {
            SetTimer this._loopRef, 0
        }
    }

    runLoop() {
        for macro in this.macros {
            if macro.getState() {
                Loop macro.getCount() {
                    if !this.isRunning {
                        break
                    }
                    macro.run()
                }
            }
        }
    }
}

importModules() {
    modulesDir := A_ScriptDir "\Modules"
    loaderFile := A_ScriptDir "\loader.ahk"

    loaderHandle := FileOpen(loaderFile, "w")
    loaderHandle.WriteLine("; DO NOT TOUCH")
    Loop Files, modulesDir "\*.ahk"
    {
        relativePath := ".\Modules\" A_LoopFileName
        loaderHandle.WriteLine("#Include " relativePath)
    }

    loaderHandle.Close()
}

GetModuleClassNames(dirPath) {
    names := []
    Loop Files, dirPath "\*.ahk" {
        className := RegExReplace(A_LoopFileName, "\.ahk$")
        names.Push(className)
    }
    return names
}

F8::manager.toggle()
