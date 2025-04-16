#Requires AutoHotkey v2.0
#Include ./WebView2/WebView2.ahk
#Include ./WebView2/_JXON.ahk
IsString(value) {
    return (Type(value) == "string")
}

main := Gui()
main.Icon := A_ScriptDir "./sofar.ico"
main.OnEvent("Close", (*) => ExitApp()) 
main.Show(Format("w{} h{}", A_ScreenWidth * 0.6, A_ScreenHeight * 0.6)) 

wvc := WebView2.CreateControllerAsync(main.Hwnd).Await() 
wv := wvc.CoreWebView2

wv.add_WebMessageReceived(WebView2.Handler(WebMessageReceivedEventHandler))
wv.Navigate("file:///" A_ScriptDir "\HTML\mainpage.html") 

WebMessageReceivedEventHandler(handler, ICoreWebView2, WebMessageReceivedEventArgs) {
    args := WebView2.WebMessageReceivedEventArgs(WebMessageReceivedEventArgs)
    msg := args.TryGetWebMessageAsString() 

    jsonObj := jxon_load(&msg)
    
    action := jsonObj.Get("action")
    
    if action == "bubblegum" {
        toggle := jsonObj.Get("params").Get("toggle")
        count := jsonObj.Get("params").Get("count")
    }
}
