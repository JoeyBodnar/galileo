//
//  AuthenticationWindowController.swift
//  Nicea
//
//  Created by Stephen Bodnar on 3/25/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import AppKit

final class WebViewWindowController: NSWindowController {
    
    override init(window: NSWindow?) {
        super.init(window: window)
    }
    
    convenience init(contentType: WebViewControllerContentType) {
        let webViewVc: WebViewController = WebViewController(contentType: contentType)
        self.init(window: NSWindow(contentViewController: webViewVc))
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
