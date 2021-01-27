#  Quicklook extension bugs test on Big Sur

Bugs test for quicklook appex on Big Sur (11.1). On Catalina these bugs do not exists.

This app handle preview of files with .sbarex_text extensions. The preview show a fake contents inside a WKWebView.

1. ~~WKWebView process fail immediately when the preview is opened~~ (the `com.apple.security.network.client` entitlement is always ignored). See [webkit bug 219632](https://bugs.webkit.org/show_bug.cgi?id=219632). The temporary workaround is to set `com.apple.nsurlsessiond` in the `com.apple.security.temporary-exception.mach-lookup.global-name` entitlement[^footnote_1]. Fixed on [WebKit Changeset 271895](https://trac.webkit.org/changeset/271895/webkit).

2. Scrollbar is not usable. When you click & draw on the scroller you drag the window without scroll.

3. WKWebView cannot be scrolled with trackpad gesture in a fullscreen QL preview [^footnote1]. See (webkit bug 220197)[https://bugs.webkit.org/show_bug.cgi?id=220197].

4. External links inside a WKWebView are open on the Quick Look preview and not in the default browser.

5. `NSWorkspace.shared.open` always fail. On the Console this is the log:

`
Launch Services generated an error at +[_LSRemoteOpenCall(PrivateCSUIAInterface) invokeWithXPCConnection:object:]:455, converting to OSStatus -54: Error Domain=NSOSStatusErrorDomain Code=-54 "The sandbox profile of this process is missing "(allow lsopen)", so it cannot invoke Launch Services' open API." UserInfo={NSDebugDescription=The sandbox profile of this process is missing "(allow lsopen)", so it cannot invoke Launch Services' open API., _LSLine=455, _LSFunction=+[_LSRemoteOpenCall(PrivateCSUIAInterface) invokeWithXPCConnection:object:]}
`
In this example application `NSWorkspace.shared.open` is used to open the external link on the default browser.

5. On a WKWebView internal link works with a delay between click and the scroll to the destination anchor. During the pause the console show a warning about Quick Look Preview do not allow first responder view.

6. On a WKWebView, customize the light/dark appearance with a CSS with  `@media (prefers-color-scheme: dark) { }`  and `:root` vars fail switching the preview to fullscreen[^footnote_2]. See [webkit bug 219632](https://bugs.webkit.org/show_bug.cgi?id=220367).
```css
:root {
  --backgroundColor: #eeeeee;
  --textColor: #333333;
}

.myclass {
    color: blue;
}
@media (prefers-color-scheme: dark) {
    :root {
        /* BUG: these var is used always when in preview on fullscreen. */
        --backgroundColor: #333333;
        --textColor: #eeeeee;
    }
    .myclass {
        /* These style respect the light/dark appearance also in fullscreen mode. */
        color: yellow;
    }
}

body {
  color: var(--textColor);
  background-color: var(--backgroundColor);
}
```
In a normal Quick Look view the theme works well, but switching to fullscreen the appearance is dark also if the macOS in on light mode.
This occurs only defining the dark style with `:root` vars. Settings the style with CSS classes that do not use custom vars is not affected by this bug.

---
[^footnote_1]: These WebKit bugs occurs only with the WKWebView. If I use the old WebView the preview works correctly.
[^footnote_2]: This bug occurs both with WKWebView and the deprecated  WebView.
