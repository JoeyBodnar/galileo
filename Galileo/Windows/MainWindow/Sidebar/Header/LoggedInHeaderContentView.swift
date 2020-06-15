//
//  LoggedInHeaderContentView.swift
//  Nicea
//
//  Created by Stephen Bodnar on 4/8/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import AppKit
import APIClient

protocol LoggedInHeaderContentViewDelegate: AnyObject {
    
    func loggedInHeaderContentViewDidSelectLogout(_ loggedInHeaderContentView: LoggedInHeaderContentView)
}

final class LoggedInHeaderContentView: NSView {
    
    private let mailButton: ImageButton = ImageButton()
    private let usernameButton: ClearButton = ClearButton()
    private let karmaLabel: NSLabel = NSLabel()
    
    private let logoutButton: ClearButton = ClearButton()
    
    weak var delegate: LoggedInHeaderContentViewDelegate?
    
    var hasUnread: Bool = false {
        didSet {
            let tintColor = hasUnread ? NSColor.red : NSColor.gray
            mailButton.image = NSImage(named: ImageNames.mailFill)?.image(withTintColor: tintColor)
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
    
    func setup(user: User) {
        usernameButton.title = user.name
        karmaLabel.stringValue = "\(user.linkKarma + user.commentKarma)"
        hasUnread = user.inboxCount > 0
    }
    
    @objc func didSelectMailBox() {
        showCommentListWindow(type: .mailbox)
    }
    
    @objc func didSelectUsername() {
        showCommentListWindow(type: .userProfile(username: usernameButton.title))
    }
    
    /// called from MailViewModel when the user reads their mail and we mark it as read
    @objc func didReadMail() {
        DispatchQueue.main.async { [weak self] in
            self?.hasUnread = false
        }
    }
    
    @objc func logoutPressed() {
        let alert: NSAlert = NSAlert()
        alert.alertStyle = .warning
        alert.messageText = "Are you sure you want to log out?"
        alert.informativeText = "If you log out, you will have to log back in to vote and comment."
        
        alert.addButton(withTitle: "Logout now")
        alert.addButton(withTitle: "No")
        
        let response: NSApplication.ModalResponse = alert.runModal()
        switch response {
        case .alertFirstButtonReturn: logoutNow()
        default: break
        }
    }
    
    // MARK: - Private
    
    private func showCommentListWindow(type: CommentListType) {
        CommentListWindowController.present(fromWindow: self.window, commentListType: .userProfile(username: usernameButton.title))
    }
    
    private func logoutNow() {
        delegate?.loggedInHeaderContentViewDidSelectLogout(self)
    }
}

extension LoggedInHeaderContentView {
    
    private func setupViews() {
        logoutButton.title = "×"
        logoutButton.font = NSFont.systemFont(ofSize: 15)
        logoutButton.target = self
        logoutButton.action = #selector(logoutPressed)
        
        usernameButton.font = NSFont.systemFont(ofSize: 11)
        usernameButton.stringValue = ""
        
        karmaLabel.font = NSFont.systemFont(ofSize: 10)
        karmaLabel.stringValue = ""
        
        mailButton.image = NSImage(named: ImageNames.mailFill)?.image(withTintColor: NSColor.gray)
        mailButton.target = self
        mailButton.action = #selector(didSelectMailBox)
        
        usernameButton.contentTintColor = NSColor.white
        usernameButton.alignment = .left
        usernameButton.target = self
        usernameButton.action = #selector(didSelectUsername)
        
        NotificationCenter.default.addObserver(self, selector: #selector(didReadMail), name: .didReadMail, object: nil)
    }
    
    private func layoutViews() {
        mailButton.setupForAutolayout(superView: self)
        usernameButton.setupForAutolayout(superView: self)
        karmaLabel.setupForAutolayout(superView: self)
        logoutButton.setupForAutolayout(superView: self)
        
        mailButton.leadingAnchor.constraint(equalTo: leadingAnchor).activate()
        mailButton.centerYAnchor.constraint(equalTo: centerYAnchor).activate()
        mailButton.heightAnchor.constraint(equalToConstant: 18).activate()
        mailButton.widthAnchor.constraint(equalTo: mailButton.heightAnchor, multiplier: 142 / 110).activate()
        
        usernameButton.leadingAnchor.constraint(equalTo: mailButton.trailingAnchor, constant: 8).activate()
        usernameButton.topAnchor.constraint(equalTo: mailButton.topAnchor, constant: -5).activate()
        usernameButton.trailingAnchor.constraint(equalTo: logoutButton.leadingAnchor).activate()
        
        karmaLabel.leadingAnchor.constraint(equalTo: usernameButton.leadingAnchor).activate()
        karmaLabel.topAnchor.constraint(equalTo: usernameButton.bottomAnchor).activate()
        karmaLabel.trailingAnchor.constraint(equalTo: usernameButton.trailingAnchor).activate()
        
        logoutButton.centerYAnchor.constraint(equalTo: mailButton.centerYAnchor).activate()
        logoutButton.heightAnchor.constraint(equalToConstant: 16).activate()
        logoutButton.widthAnchor.constraint(equalToConstant: 16).activate()
        logoutButton.trailingAnchor.constraint(equalTo: trailingAnchor).activate()
    }
}
