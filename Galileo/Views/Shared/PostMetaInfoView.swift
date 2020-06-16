//
//  PostMetaInfoView.swift
//  Nicea
//
//  Created by Stephen Bodnar on 3/28/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import AppKit
import APIClient

/// The view at the top of a post that contains meta info abot the post, such as its subreddit, the author, and time ago posted
final class PostMetaInfoView: NSView {
    
    private let postedByLabel: NSLabel = NSLabel()
    let subredditLinkButton: ClearButton = ClearButton()
    let usernameButton: ClearButton = ClearButton()
    let timeButton: ClearButton = ClearButton()
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        commonInit()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func commonInit() {
        layoutViews()
        setupViews()
    }
    
    func configure(link: Link) {
        subredditLinkButton.title = link.data.subreddit
        usernameButton.title = link.data.author
        let date: Date = Date(timeIntervalSince1970: TimeInterval(link.data.created_utc))
        timeButton.title = "\(date.timeAgoSince()) in"
    }
    
    @objc func subredditButtonPressed() {
        let mainWindowController = MainWindowController(initialSubreddit: subredditLinkButton.title)
        window?.addTabbedWindow(mainWindowController.window!, ordered: NSWindow.OrderingMode.above)
        mainWindowController.window?.orderFront(self)
    }
    
    @objc func usernameButtonPressed() {
        CommentListWindowController.present(fromWindow: self.window, commentListType: .userProfile(username: usernameButton.title))
    }
}

// MARK: - Layout/Setup
extension PostMetaInfoView {
    
    private func setupViews() {
        postedByLabel.font = NSFont.systemFont(ofSize: 10)
        postedByLabel.stringValue = "posted by"
        
        usernameButton.font = NSFont.systemFont(ofSize: 10)
        usernameButton.target = self
        usernameButton.action = #selector(usernameButtonPressed)
        
        timeButton.font = NSFont.systemFont(ofSize: 10)
        
        subredditLinkButton.font = NSFont.systemFont(ofSize: 10)
        subredditLinkButton.target = self
        subredditLinkButton.action = #selector(subredditButtonPressed)
    }
    
    private func layoutViews() {
        postedByLabel.setupForAutolayout(superView: self)
        subredditLinkButton.setupForAutolayout(superView: self)
        usernameButton.setupForAutolayout(superView: self)
        timeButton.setupForAutolayout(superView: self)
        
        postedByLabel.leadingAnchor.constraint(equalTo: leadingAnchor).activate()
        postedByLabel.centerYAnchor.constraint(equalTo: centerYAnchor).activate()
        
        usernameButton.leadingAnchor.constraint(equalTo: postedByLabel.trailingAnchor, constant: 0).activate()
        usernameButton.centerYAnchor.constraint(equalTo: centerYAnchor).activate()
        
        timeButton.leadingAnchor.constraint(equalTo: usernameButton.trailingAnchor, constant: 0).activate()
        timeButton.centerYAnchor.constraint(equalTo: centerYAnchor).activate()
        
        subredditLinkButton.leadingAnchor.constraint(equalTo: timeButton.trailingAnchor, constant: 0).activate()
        subredditLinkButton.centerYAnchor.constraint(equalTo: centerYAnchor).activate()
    }
}
