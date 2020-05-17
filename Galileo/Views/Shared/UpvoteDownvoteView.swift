//
//  UpvoteDownvoteView.swift
//  Nicea
//
//  Created by Stephen Bodnar on 3/28/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import AppKit
import APIClient

protocol UpvoteDownvoteViewDelegate: AnyObject {
    func didPressVote(_ upvoteDownvoteView: UpvoteDownvoteView, direction: VoteDirection)
}

enum UpvoteDownvoteViewStyle {
    case post
    case comment
    
    var heightWidthConstraint: CGFloat {
        switch self {
        case .post: return 20
        case .comment: return 10
        }
    }
}

/// The view for voting on posts
final class UpvoteDownvoteView: VotableView {
    
    private let upButton: ImageButton = ImageButton()
    private let downButton: ImageButton = ImageButton()
    
    weak var delegate: UpvoteDownvoteViewDelegate?
    
    var state: VoteDirection = .none {
        didSet {
            setVoteStatus()
        }
    }
    
    var style: UpvoteDownvoteViewStyle = .post {
        didSet {
            upButtonHeightAnchor.constant = style.heightWidthConstraint
            upButtonWidthAnchor.constant = style.heightWidthConstraint
            downButtonHeightAnchor.constant = style.heightWidthConstraint
            downButtonWidthAnchor.constant = style.heightWidthConstraint
        }
    }
    
    private var upButtonHeightAnchor: NSLayoutConstraint = NSLayoutConstraint()
    private var upButtonWidthAnchor: NSLayoutConstraint = NSLayoutConstraint()
    private var downButtonHeightAnchor: NSLayoutConstraint = NSLayoutConstraint()
    private var downButtonWidthAnchor: NSLayoutConstraint = NSLayoutConstraint()
    
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
    
    func configure(voteCount: Int, hideScore: Bool, likes: Bool?) {
        self.hideScore = hideScore
        self.voteCount = voteCount
        
        if let upvoted = likes {
            state = upvoted ? VoteDirection.up : VoteDirection.down
        } else {
            state = .none
        }
    }
    
    @objc func upvote() {
        if !SessionManager.shared.isLoggedIn { return }
        switch state {
        case .up: // if already up, then decrement
            voteCount = voteCount - 1
            vote(direction: .none)
        case .down: // if have already downvoted, then incremend
            voteCount = voteCount + 2
            vote(direction: .up)
        case .none:
            voteCount = voteCount + 1
            vote(direction: .up)
        }
    }
    
    @objc func downvote() {
        if !SessionManager.shared.isLoggedIn { return }
        switch state {
        case .down:
            voteCount = voteCount + 1
            vote(direction: .none)
        case .up:
            voteCount = voteCount - 2
            vote(direction: .down)
        case .none:
            voteCount = voteCount - 1
            vote(direction: .down)
        }
    }
    
    private func vote(direction: VoteDirection) {
        if !SessionManager.shared.isLoggedIn { return }
        delegate?.didPressVote(self, direction: direction)
        state = direction
    }
    
    private func setVoteStatus() {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            switch strongSelf.state {
            case .up:
                strongSelf.upButton.image = NSImage(named: ImageNames.chevronUp)?.image(withTintColor: NSColor.controlAccentColor)
                strongSelf.downButton.image = NSImage(named: ImageNames.chevronDown)?.image(withTintColor: NSColor.textColor)
            case .down:
                strongSelf.upButton.image = NSImage(named: ImageNames.chevronUp)?.image(withTintColor: NSColor.textColor)
                strongSelf.downButton.image = NSImage(named: ImageNames.chevronDown)?.image(withTintColor: NSColor.controlAccentColor)
            case .none:
                strongSelf.upButton.image = NSImage(named: ImageNames.chevronUp)?.image(withTintColor: NSColor.textColor)
                strongSelf.downButton.image = NSImage(named: ImageNames.chevronDown)?.image(withTintColor: NSColor.textColor)
            }
        }
    }
    
}

extension UpvoteDownvoteView {
    
    private func setupViews() {
        voteLabel.font = NSFont.systemFont(ofSize: 10)
        voteLabel.stringValue = ""
        
        state = .none
        
        upButton.target = self
        downButton.target = self
        upButton.action = #selector(upvote)
        downButton.action = #selector(downvote)
        
        style = .post
    }
    
    private func layoutViews() {
        upButton.setupForAutolayout(superView: self)
        downButton.setupForAutolayout(superView: self)
        voteLabel.setupForAutolayout(superView: self)
        
        upButton.topAnchor.constraint(equalTo: topAnchor, constant: 1).activate()
        upButton.centerXAnchor.constraint(equalTo: centerXAnchor).activate()
        upButtonHeightAnchor = upButton.heightAnchor.constraint(equalToConstant: 20)
        upButtonHeightAnchor.activate()
        upButtonWidthAnchor = upButton.widthAnchor.constraint(equalToConstant: 20)
        upButtonWidthAnchor.activate()
        
        voteLabel.center(in: self)
        
        downButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -1).activate()
        downButton.centerXAnchor.constraint(equalTo: centerXAnchor).activate()
        downButtonHeightAnchor = downButton.heightAnchor.constraint(equalToConstant: 20)
        downButtonHeightAnchor.activate()
        downButtonWidthAnchor = downButton.widthAnchor.constraint(equalToConstant: 20)
        downButtonWidthAnchor.activate()
    }
}
