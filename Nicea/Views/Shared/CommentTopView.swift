//
//  CommentTopView.swift
//  Nicea
//
//  Created by Stephen Bodnar on 4/17/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import AppKit
import APIClient

/// View at the top of a comment that has the commenters name, the number of upvotes, and the time ago
final class CommentTopView: VotableView {
    
    let authorButton: ClearButton = ClearButton()
    let dateLabel: NSLabel = NSLabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    private func commonInit() {
        layoutViews()
        setupViews()
    }
    
    func configure(comment: Comment) {
        hideScore = comment.data.scoreHidden ?? false
        
        authorButton.title = comment.data.author ?? ""
        let date: Date = Date(timeIntervalSince1970: TimeInterval(comment.data.createdAt ?? 0))
        dateLabel.stringValue = "\(date.timeAgoSince())"
        
        voteCount = comment.data.score ?? 1
    }
    
    func vote(direction: VoteDirection, currentDirection: VoteDirection) {
        switch currentDirection {
        case .up:
            switch direction {
            case .up: voteCount = voteCount - 1
            case .down: voteCount = voteCount - 2
            case .none: voteCount = voteCount - 1
            }
        case .down:
            switch direction {
            case .up: voteCount = voteCount + 2
            case .down: voteCount = voteCount + 1
            case .none: voteCount = voteCount + 1
            }
        case .none:
            switch direction {
            case .up: voteCount = voteCount + 1
            case .down: voteCount = voteCount - 1
            case .none: break // cannot choose "none"
            }
        }
    }
}

// MARK: - Layout/Setup
extension CommentTopView {
    
    private func setupViews() {
        wantsLayer = true
        layer?.backgroundColor = NSColor.clear.cgColor
        
        authorButton.font = NSFont.systemFont(ofSize: 10)
        voteLabel.font = NSFont.systemFont(ofSize: 10)
        dateLabel.font = NSFont.systemFont(ofSize: 10)
        
        displayPointsText = true
    }
    
    private func layoutViews() {
        authorButton.setupForAutolayout(superView: self)
        voteLabel.setupForAutolayout(superView: self)
        dateLabel.setupForAutolayout(superView: self)
        
        authorButton.leadingAnchor.constraint(equalTo: leadingAnchor).activate()
        authorButton.centerYAnchor.constraint(equalTo: centerYAnchor).activate()
        
        voteLabel.leadingAnchor.constraint(equalTo: authorButton.trailingAnchor, constant: 0).activate()
        voteLabel.centerYAnchor.constraint(equalTo: authorButton.centerYAnchor).activate()
        
        dateLabel.leadingAnchor.constraint(equalTo: voteLabel.trailingAnchor, constant: 0).activate()
        dateLabel.centerYAnchor.constraint(equalTo: authorButton.centerYAnchor).activate()
    }
}

