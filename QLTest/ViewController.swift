//
//  ViewController.swift
//  QLTest
//
//  Created by Sbarex on 10/12/20.
//

import Cocoa
import WebKit
class ViewController: NSViewController {
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.webView.loadHTMLString("<html><body>hello world</body></html>", baseURL: nil)
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

