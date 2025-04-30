#Requires AutoHotkey v2.0+
#SingleInstance Force
#Include <WebView2>
#Include <javascript_strings>

g := Gui('+Resize', 'Web Browser')
input := g.Add('Edit', 'w750 h25', 'http://www.example.com')
browser := g.AddText('w835 h600', '') ;Create a blank text area for the browser window
btn := g.Add('Button', 'xp760 yp-32.5 w75 h25 Default', 'Go')
btn.OnEvent('Click', navigate)
g.Show()
g.OnEvent('size', OnResize)
g.OnEvent('close', (*) => ExitApp())

wv := WebView2.create(browser.Hwnd) ;initialize WebView2 and set the browser window to be contained by the blank text area
javascript := wv.CoreWebView2   ;create a handler object to be used for navigation and controlling webview2
javascript.Navigate('http://www.google.com')    ;navigate to default home page (I chose google.com)

navigate(*) {
    url := input.value
    if (url == '') {
        MsgBox('Please enter a URL.')
        return
    }
    if (!url.match('^https?://')) { ;Depends on javascript_strings but can be rewritten using AHKs built-in RegExMatch function
        url := 'http://' . url
    }

    javascript.Navigate(url)
}

onResize(*) { ;Handle window resizing - move elements to match the new window size
    g.GetClientPos(&x, &y, &w, &h)
    input.Move(,, w-105)
    btn.Move(w-85)
    browser.Move(,, w-20, h-45) ;resize the blank text area to match the size of the window
    wv.fill()   ;Tell webview2 to resize itself to match the new size of the blank text area
}
