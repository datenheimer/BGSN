#Requires AutoHotkey v2.0
#Include ./WebView2/WebView2.ahk

main := Gui()
main.OnEvent("Close", (*) => ExitApp())  
main.Show(Format("w{} h{}", A_ScreenWidth * 0.6, A_ScreenHeight * 0.6)) 

wvc := WebView2.CreateControllerAsync(main.Hwnd).Await() 
wv := wvc.CoreWebView2

wv.add_WebMessageReceived(WebView2.Handler(WebMessageReceivedEventHandler)) 
wv.Navigate("file:///" A_ScriptDir "\HTML\mainpage.html")


WebMessageReceivedEventHandler(handler, ICoreWebView2, WebMessageReceivedEventArgs) {
    args := WebView2.WebMessageReceivedEventArgs(WebMessageReceivedEventArgs)
    msg := args.TryGetWebMessageAsString()

}

RunMacro(toggle, count) {
    MsgBox("Running macro with toggle: " toggle " and count: " count)

    if (toggle = "on") {
        MsgBox("Toggle is ON! Proceeding with the macro...")
    } else {
        MsgBox("Toggle is OFF! Skipping the macro...")
        return false
    }

    Loop count {
        Run "C:\Program Files\WindowsApps\Microsoft.WindowsNotepad_11.2501.31.0_x64__8wekyb3d8bbwe\Notepad\Notepad.exe"
    }

    return true
}
