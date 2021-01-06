//
//  external_launcher.swift
//  external-launcher
//
//  Created by Sbarex on 30/12/20.
//

import Cocoa

class ExternalLauncherService: NSObject, ExternalLauncherProtocol {
    func open(_ url: URL, withReply reply: @escaping (Error?) -> Void) {
        let task = Process()
        task.executableURL = URL(fileURLWithPath: "/usr/bin/qlmanage")
        task.arguments = ["-p", url.path]
        task.waitUntilExit()
        do {
            try task.run()
            reply(nil)
        } catch {
            reply(error)
        }
    }
}
