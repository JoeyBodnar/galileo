//
//  PostMetaInfoBottomView.swift
//  Nicea
//
//  Created by Stephen Bodnar on 3/28/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import AppKit
import APIClient

protocol PostMetaInfoBottomViewDelegate: AnyObject {
    
    func postMetaInfoBottomView(_ postMetaInfoBottomView: PostMetaInfoBottomView, didSelectViewComments button: ClearButton)
    func postMetaInfoBottomView(_ postMetaInfoBottomView: PostMetaInfoBottomView, didSelectSave button: ClearButton)
    func postMetaInfoBottomView(_ postMetaInfoBottomView: PostMetaInfoBottomView, didSelectShare button: ClearButton)
}

/// The info view at the bottom of posts and comments, containing reply/comment button, and save and share button
final class PostMetaInfoBottomView: NSView {
    
    let commentButton: ClearButton = ClearButton()
    let saveButton: ClearButton = ClearButton()
    let shareButton: ClearButton = ClearButton()
    
    weak var delegate: PostMetaInfoBottomViewDelegate?
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        layoutViews()
        setupViews()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layoutViews()
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @objc func commentsPressed() {
        delegate?.postMetaInfoBottomView(self, didSelectViewComments: commentButton)
    }
    
    @objc func savePressed() {
        if !SessionManager.shared.isLoggedIn { return }
        delegate?.postMetaInfoBottomView(self, didSelectSave: saveButton)
        if saveButton.title == Strings.saveButtonDefaultText {
            saveButton.title = Strings.saveButtonInProgressButtonText
        } else {
            saveButton.title = Strings.saveButtonUnsaveInProgressText
        }
    }
    
    @objc func sharePressed() {
        delegate?.postMetaInfoBottomView(self, didSelectShare: shareButton)
    }
    
    func configure(link: Link) {
        let commentCount: Int = link.data.num_comments
        let commentsText: String = commentCount == 1 ? Strings.comment : Strings.comments
        commentButton.title = "\(commentCount) \(commentsText)"
        
        let isSaved: Bool = link.data.saved ?? false
        saveButton.title = isSaved ? Strings.saveButtonUnsaveText : Strings.saveButtonDefaultText
    }
    
    func configure(comment: Comment) {
        commentButton.title = Strings.reply
        
        let isSaved: Bool = comment.data.saved ?? false
        saveButton.title = isSaved ? Strings.saveButtonUnsaveText : Strings.saveButtonDefaultText
    }
}

// MARK: - Layout/Setup
extension PostMetaInfoBottomView {
    
    private func setupViews() {
        saveButton.title = Strings.saveButtonDefaultText
        shareButton.title = Strings.shareButtonText
        
        commentButton.font = NSFont.systemFont(ofSize: 10)
        saveButton.font = NSFont.systemFont(ofSize: 10)
        shareButton.font = NSFont.systemFont(ofSize: 10)
        
        commentButton.target = self
        commentButton.action = #selector(commentsPressed)
        
        saveButton.target = self
        saveButton.action = #selector(savePressed)
        
        shareButton.target = self
        shareButton.action = #selector(sharePressed)
    }
    
    private func layoutViews() {
        commentButton.setupForAutolayout(superView: self)
        saveButton.setupForAutolayout(superView: self)
        shareButton.setupForAutolayout(superView: self)
        
        commentButton.leadingAnchor.constraint(equalTo: leadingAnchor).activate()
        commentButton.centerYAnchor.constraint(equalTo: centerYAnchor).activate()
        
        saveButton.leadingAnchor.constraint(equalTo: commentButton.trailingAnchor).activate()
        saveButton.centerYAnchor.constraint(equalTo: centerYAnchor).activate()
        
        shareButton.leadingAnchor.constraint(equalTo: saveButton.trailingAnchor).activate()
        shareButton.centerYAnchor.constraint(equalTo: centerYAnchor).activate()
    }
}
