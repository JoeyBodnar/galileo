//
//  MailWindowController.swift
//  Nicea
//
//  Created by Stephen Bodnar on 4/16/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import AppKit

final class MailWindowController: NSWindowController {
    
    override func loadWindow() {
        super.loadWindow()
        contentViewController = MailViewController()
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        guard let windowSize: NSSize = window?.frame.size else { return }
        let mailVc: MailViewController = MailViewController()
        mailVc.view.setFrameSize(windowSize)
        contentViewController = MailViewController()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
