//
//  HeaderView.swift
//  Nicea
//
//  Created by Stephen Bodnar on 3/24/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import AppKit
import APIClient

protocol HeaderViewDelegate: AnyObject {
    func headerView(_ headerView: HeaderView, didLoginWithUser user: User)
    func headerView(_ headerView: HeaderView, didFailToLoginWithError error: Error)
}

final class HeaderView: NSView {
    
    let loggedInView: LoggedInHeaderContentView = LoggedInHeaderContentView()
    private var loginButton: ControlAccentColorButton = ControlAccentColorButton()
    
    let seperator: NSView = NSView()
    
    weak var delegate: HeaderViewDelegate?
    
    var loggedIn: Bool = false {
        didSet {
            setAlphasForLoggedIn()
        }
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        wantsLayer = true
        
        layoutViews()
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @objc func loginPressed() {
        let webviewWindowController: WebViewWindowController = WebViewWindowController(contentType: .login)
        (webviewWindowController.window?.contentViewController as? WebViewController)?.delegate = self
        DispatchQueue.main.async {
            self.window?.addTabbedWindow(webviewWindowController.window!, ordered: NSWindow.OrderingMode.above)
            webviewWindowController.window?.orderFront(self)
        }
    }
    
    private func setAlphasForLoggedIn() {
        loginButton.alphaValue = loggedIn ? 0 : 1
        loginButton.isEnabled = !loggedIn
        loggedInView.alphaValue = loggedIn ? 1 : 0
    }
}

extension HeaderView: WebViewControllerDelegate {
    func webViewController(_ webViewController: WebViewController, withUser user: User) {
        loggedInView.setup(user: user)
        delegate?.headerView(self, didLoginWithUser: user)
        loggedIn = true
    }
    
    func webViewController(_ webViewController: WebViewController, didFailToLoginWithError error: Error) {
        loggedIn = false
        delegate?.headerView(self, didFailToLoginWithError: error)
    }
}

extension HeaderView {
    
    private func setupViews() {
        loggedIn = DefaultsManager.shared.userAuthorizationToken != nil
        seperator.wantsLayer = true
        seperator.layer?.backgroundColor = NSColor.lightGray.cgColor
        
        loginButton.title = "Login"
        loginButton.target = self
        loginButton.action = #selector(loginPressed)
    }
    
    private func layoutViews() {
        seperator.setupForAutolayout(superView: self)
        loggedInView.setupForAutolayout(superView: self)
        loginButton.setupForAutolayout(superView: self)
        
        loggedInView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).activate()
        loggedInView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -2).activate()
        loggedInView.trailingAnchor.constraint(equalTo: trailingAnchor).activate()
        loggedInView.heightAnchor.constraint(equalToConstant: 30).activate()
        
        loginButton.center(in: self)
        loginButton.widthAnchor.constraint(equalToConstant: 80).activate()
        loginButton.heightAnchor.constraint(equalToConstant: 30).activate()
        
        seperator.leadingAnchor.constraint(equalTo: leadingAnchor).activate()
        seperator.trailingAnchor.constraint(equalTo: trailingAnchor).activate()
        seperator.bottomAnchor.constraint(equalTo: bottomAnchor).activate()
        seperator.heightAnchor.constraint(equalToConstant: 2).activate()
    }
}
