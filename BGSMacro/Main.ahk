#Requires AutoHotkey v2.0
#Include ./WebView2/WebView2.ahk
#Include ./WebView2/_JXON.ahk
#Include ./Modules/bubble.ahk

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

b := Bubblegum()
MacroMap["bubblegum"] := b
manager.addMacro(b)

wv.add_WebMessageReceived(WebView2.Handler(WebMessageReceivedEventHandler))
wv.Navigate("file:///" A_ScriptDir "\HTML\mainpage.html") 

WebMessageReceivedEventHandler(handler, ICoreWebView2, WebMessageReceivedEventArgs) {
    args := WebView2.WebMessageReceivedEventArgs(WebMessageReceivedEventArgs)
    msg := args.TryGetWebMessageAsString() 
    jsonObj := jxon_load(&msg)
    action := jsonObj.Get("action")
    params := jsonObj.Get("params")

    if MacroMap.Has(action) {
        macro := MacroMap[action]
        if HasMethod(macro, "SetConfig")
            macro.SetConfig(params)
    }
}

manager.runLoop()

class MacroManager {
    __New() {
        this.macros := []
        this.isRunning := false
    }

    addMacro(macro) {
        this.macros.Push(macro)
    }

    runLoop() {
        if this.isRunning
            return
        this.isRunning := true
        while true {
            for macro in this.macros {
                if macro.getState()
                    macro.run()
            }
        }
    }
}
