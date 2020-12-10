//
//  PreviewViewController.swift
//  QLExt
//
//  Created by Sbarex on 10/12/20.
//

import Cocoa
import Quartz
import WebKit
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
        let html = "<html><body>hello world</body></html>"
        
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
        // this code fail on Big Sur.
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = false

        // Create a configuration for the preferences
        let configuration = WKWebViewConfiguration()
        //configuration.preferences = preferences
        configuration.allowsAirPlayForMediaPlayback = false
        // configuration.userContentController.add(self, name: "jsHandler")
        
        let webView = WKWebView(frame: self.view.bounds, configuration: configuration)
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
