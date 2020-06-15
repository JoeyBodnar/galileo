//
//  MailWindowController.swift
//  Nicea
//
//  Created by Stephen Bodnar on 4/16/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import AppKit

final class CommentListWindowController: NSWindowController {
    
    var commentListType: CommentListType = .mailbox
    
    override func loadWindow() {
        super.loadWindow()
        contentViewController = CommentListViewController()
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        guard let windowSize: NSSize = window?.frame.size else { return }
        let mailVc: CommentListViewController = CommentListViewController()
        mailVc.view.setFrameSize(windowSize)
        contentViewController = CommentListViewController()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
