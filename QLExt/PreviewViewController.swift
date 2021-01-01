//
//  PreviewViewController.swift
//  QLExt
//
//  Created by Sbarex on 10/12/20.
//

import Cocoa
import Quartz
import WebKit

class MyWebView: WKWebView {
    override var canBecomeKeyView: Bool {
        return false
    }
    
    override func becomeFirstResponder() -> Bool {
        return false
    }
}

class PreviewViewController: NSViewController, QLPreviewingController, WKNavigationDelegate, WKUIDelegate {
    var handler: ((Error?) -> Void)?
    
    override var nibName: NSNib.Name? {
        return NSNib.Name("PreviewViewController")
    }

    override func loadView() {
        super.loadView()
        // Do any additional setup after loading the view.
    }

    /*
     * Implement this method and set QLSupportsSearchableItems to YES in the Info.plist of the extension if you support CoreSpotlight.
     *
    func preparePreviewOfSearchableItem(identifier: String, queryString: String?, completionHandler handler: @escaping (Error?) -> Void) {
        // Perform any setup necessary in order to prepare the view.
        
        // Call the completion handler so Quick Look knows that the preview is fully loaded.
        // Quick Look will display a loading spinner while the completion handler is not called.
        handler(nil)
    }
     */
    
    func preparePreviewOfFile(at url: URL, completionHandler handler: @escaping (Error?) -> Void) {
        
        // Add the supported content types to the QLSupportedContentTypes array in the Info.plist of the extension.
        
        // Perform any setup necessary in order to prepare the view.
        
        // Call the completion handler so Quick Look knows that the preview is fully loaded.
        // Quick Look will display a loading spinner while the completion handler is not called.
        
        // On BigSur 11.0.1 the entitlements on the extesion are ignored and webkit fail to render. Old WebView works.
        
        self.handler = handler
        let html = """
<html>
<body>
        <p>1. hello world</p>
        <p>2. hello world</p>
        <p>3. hello world</p>
        <p><a href="https://www.google.com/?q=quicklook+bug">This link must open google site on the standard browser.</a></p>
        <p>4. hello world</p>
        <p><a href="#p45">this link scroll to paragraph 45</a></p>
        <p>5. hello world</p>
        <p>6. hello world</p>
        <p>7. hello world</p>
        <p>8. hello world</p>
        <p>9. hello world</p>
        <p>10. hello world</p>
        <p>11. hello world</p>
        <p>12. hello world</p>
        <p>13. hello world</p>
        <p>14. hello world</p>
        <p>15. hello world</p>
        <p>16. hello world</p>
        <p>17. hello world</p>
        <p>18. hello world</p>
        <p>19. hello world</p>
        <p>20. hello world</p>
        <p>21. hello world</p>
        <p>22. hello world</p>
        <p>23. hello world</p>
        <p>24. hello world</p>
        <p>25. hello world</p>
        <p>26. hello world</p>
        <p>27. hello world</p>
        <p>28. hello world</p>
        <p>29. hello world</p>
        <p>30. hello world</p>
        <p>31. hello world</p>
        <p>32. hello world</p>
        <p>33. hello world</p>
        <p>34. hello world</p>
        <p>35. hello world</p>
        <p>36. hello world</p>
        <p>37. hello world</p>
        <p>38. hello world</p>
        <p>39. hello world</p>
        <p>40. hello world</p>
        <p>41. hello world</p>
        <p>42. hello world</p>
        <p>43. hello world</p>
        <p>44. hello world</p>
        <p id="p45">45. hello world</p>
        <p>46. hello world</p>
        <p>47. hello world</p>
        <p>48. hello world</p>
        <p>49. hello world</p>
</body>
</html>
"""
        
        /*
        // MARK: INFO
        // This code works on Big Sur.
        let webView = WebView(frame: self.view.bounds)
        webView.autoresizingMask = [.height, .width]
        webView.preferences.isJavaScriptEnabled = false
        webView.preferences.allowsAirPlayForMediaPlayback = false
        webView.preferences.arePlugInsEnabled = false
        
        self.view.addSubview(webView)
        webView.mainFrame.loadHTMLString(html, baseURL: nil)
        webView.frameLoadDelegate = self
        
        */
        
        
        // MARK: FIXME
        // this code fail on Big Sur without the com.apple.security.temporary-exception.mach-lookup.global-name entitlement for process com.apple.nsurlsessiond.
        
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = false

        // Create a configuration for the preferences
        let configuration = WKWebViewConfiguration()
        //configuration.preferences = preferences
        configuration.allowsAirPlayForMediaPlayback = false
        // configuration.userContentController.add(self, name: "jsHandler")
        
        let webView = MyWebView(frame: self.view.bounds, configuration: configuration)
        webView.autoresizingMask = [.height, .width]
        
        webView.wantsLayer = true
        if #available(macOS 11, *) {
            webView.layer?.borderWidth = 0
        } else {
            // Draw a border around the web view
            webView.layer?.borderColor = NSColor.gridColor.cgColor
            webView.layer?.borderWidth = 1
        }
    
        webView.navigationDelegate = self
        webView.uiDelegate = self

        webView.loadHTMLString(html, baseURL: nil)
        self.view.addSubview(webView)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if let handler = self.handler {
            handler(nil)
            self.handler = nil
        }
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        if let handler = self.handler {
            handler(error)
            self.handler = nil
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.navigationType == .linkActivated, let url = navigationAction.request.url {
            // FIXME: on big sur fail with this error on Console:
            // Launch Services generated an error at +[_LSRemoteOpenCall(PrivateCSUIAInterface) invokeWithXPCConnection:object:]:455, converting to OSStatus -54: Error Domain=NSOSStatusErrorDomain Code=-54 "The sandbox profile of this process is missing "(allow lsopen)", so it cannot invoke Launch Services' open API." UserInfo={NSDebugDescription=The sandbox profile of this process is missing "(allow lsopen)", so it cannot invoke Launch Services' open API., _LSLine=455, _LSFunction=+[_LSRemoteOpenCall(PrivateCSUIAInterface) invokeWithXPCConnection:object:]}
            let r = NSWorkspace.shared.open(url)
            if r {
                decisionHandler(.cancel)
                return
            } else {
                print("Unable to open on the exteral browser: ", url.absoluteString)
            }
        }
        decisionHandler(.allow)
    }
}

@available(macOS, deprecated: 10.14)
extension PreviewViewController: WebFrameLoadDelegate {
    func webView(_ sender: WebView!, didFinishLoadFor frame: WebFrame!) {
        if let handler = self.handler {
            handler(nil)
        }
        self.handler = nil
    }
    func webView(_ sender: WebView!, didFailLoadWithError error: Error!, for frame: WebFrame!) {
        if let handler = self.handler {
            handler(error)
        }
        self.handler = nil
    }
}
