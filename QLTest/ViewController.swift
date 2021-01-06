//
//  ViewController.swift
//  QLTest
//
//  Created by Sbarex on 10/12/20.
//

import Cocoa
import WebKit
import openql

class ViewController: NSViewController {
    @IBOutlet weak var textView: NSTextView!
    
    var launcherService: ExternalLauncherProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.textView.string = (try? String(contentsOfFile: Bundle.main.path(forResource: "README", ofType: "md")!)) ?? ""
        
        let connection = NSXPCConnection(serviceName: "org.sbarex.qltest.openql")
        
        connection.remoteObjectInterface = NSXPCInterface(with: ExternalLauncherProtocol.self)
        connection.resume()
        
        self.launcherService = connection.synchronousRemoteObjectProxyWithErrorHandler { error in
            print("Received error:", error)
        } as? ExternalLauncherProtocol
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func handleButton(_ sender: Any) {
        self.launcherService?.open(Bundle.main.url(forResource: "test", withExtension: "sbarex_test")!, withReply: { error in
            if let e = error {
                print(e)
            }
        })
        
    }
    @IBAction func handleReveal(_ sender: Any) {
        NSWorkspace.shared.selectFile(Bundle.main.url(forResource: "test", withExtension: "sbarex_test")!.path, inFileViewerRootedAtPath: "")
    }
}

