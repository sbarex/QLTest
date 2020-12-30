#  Quicklook extension bugs test on Big Sur

Bug test for quicklook appex on Big Sur (11.1). On Catalina these bugs do not exists.

This app handle preview of files with .sbarex_text extensions. The preview show a fake contents with a webview.

1. WKWebView process fail immediately when the preview is opened (the `com.apple.security.network.client` entitlement is always ignored). See [webkit bug 219632](https://bugs.webkit.org/show_bug.cgi?id=219632). The temporary workaround is to set `com.apple.nsurlsessiond` in the `com.apple.security.temporary-exception.mach-lookup.global-name` entitlement[^footnote1].

2. Scrollbar is not usable. When you click & draw on the scroller you drag the window without scroll.

3. WKWebView cannot be scrolled with trackpad gesture in a fullscreen QL preview [^footnote1]. See (webkit bug 220197)[https://bugs.webkit.org/show_bug.cgi?id=220197].

4. Links inside a WKWebView are open on the quicklook preview and if you try to open on an external browser with `NSWorkspace.shared.open` always fail. On the Console this is the log:

`
Launch Services generated an error at +[_LSRemoteOpenCall(PrivateCSUIAInterface) invokeWithXPCConnection:object:]:455, converting to OSStatus -54: Error Domain=NSOSStatusErrorDomain Code=-54 "The sandbox profile of this process is missing "(allow lsopen)", so it cannot invoke Launch Services' open API." UserInfo={NSDebugDescription=The sandbox profile of this process is missing "(allow lsopen)", so it cannot invoke Launch Services' open API., _LSLine=455, _LSFunction=+[_LSRemoteOpenCall(PrivateCSUIAInterface) invokeWithXPCConnection:object:]}
`

---
[^footnote1]: These WebKit bugs occurs only with the WKWebView. If I use the old WebView the preview works correctly.

