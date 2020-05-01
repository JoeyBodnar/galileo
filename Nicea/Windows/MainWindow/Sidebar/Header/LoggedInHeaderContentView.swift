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
    func loggedInHeaderContentView(_ loggedInHeaderContentView: LoggedInHeaderContentView, didSelectMailButton button: ImageButton, withEmptyMailbox mailBoxIsEmpty: Bool)
}

final class LoggedInHeaderContentView: NSView {
    
    private let mailButton: ImageButton = ImageButton()
    private let usernameLabel: NSLabel = NSLabel()
    private let karmaLabel: NSLabel = NSLabel()
    
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
        usernameLabel.stringValue = user.name
        karmaLabel.stringValue = "\(user.linkKarma + user.commentKarma)"
        hasUnread = user.inboxCount > 0
    }
    
    @objc func didSelectMailBox() {
        let storyboard: NSStoryboard = NSStoryboard(name: StoryboardIds.Main, bundle: nil)
        let mailWindowController: MailWindowController = storyboard.instantiateController(withIdentifier: StoryboardIds.MailWindowController) as! MailWindowController
        DispatchQueue.main.async {
            self.window?.addTabbedWindow(mailWindowController.window!, ordered: NSWindow.OrderingMode.above)
            mailWindowController.window?.orderFront(self)
        }
    }
    
    /// called from MailViewModel when the user reads their mail and we mark it as read
    @objc func didReadMail() {
        DispatchQueue.main.async { [weak self] in
            self?.hasUnread = false
        }
    }
}

extension LoggedInHeaderContentView {
    
    private func setupViews() {
        usernameLabel.font = NSFont.systemFont(ofSize: 11)
        usernameLabel.stringValue = ""
        
        karmaLabel.font = NSFont.systemFont(ofSize: 10)
        karmaLabel.stringValue = ""
        
        mailButton.image = NSImage(named: ImageNames.mailFill)?.image(withTintColor: NSColor.gray)
        mailButton.target = self
        mailButton.action = #selector(didSelectMailBox)
        
        NotificationCenter.default.addObserver(self, selector: #selector(didReadMail), name: .didReadMail, object: nil)
    }
    
    private func layoutViews() {
        mailButton.setupForAutolayout(superView: self)
        usernameLabel.setupForAutolayout(superView: self)
        karmaLabel.setupForAutolayout(superView: self)
        
        mailButton.leadingAnchor.constraint(equalTo: leadingAnchor).activate()
        mailButton.centerYAnchor.constraint(equalTo: centerYAnchor).activate()
        mailButton.heightAnchor.constraint(equalToConstant: 18).activate()
        mailButton.widthAnchor.constraint(equalTo: mailButton.heightAnchor, multiplier: 142 / 110).activate()
        
        usernameLabel.leadingAnchor.constraint(equalTo: mailButton.trailingAnchor, constant: 8).activate()
        usernameLabel.topAnchor.constraint(equalTo: mailButton.topAnchor, constant: -5).activate()
        usernameLabel.trailingAnchor.constraint(equalTo: trailingAnchor).activate()
        
        karmaLabel.leadingAnchor.constraint(equalTo: usernameLabel.leadingAnchor).activate()
        karmaLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor).activate()
        karmaLabel.trailingAnchor.constraint(equalTo: usernameLabel.trailingAnchor).activate()
    }
}
