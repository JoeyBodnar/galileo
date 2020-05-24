//
//  CommentTableViewCell.swift
//  Nicea
//
//  Created by Stephen Bodnar on 4/17/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import AppKit
import APIClient
import CocoaMarkdown

protocol CommentTableViewCellViewDelegate: AnyObject {
    
    func commentTableViewCellView(_ commentTableViewCellView: CommentTableViewCellView, didSelectReply comment: Comment)
    func commentTableViewCellView(_ commentTableViewCellView: CommentTableViewCellView, didVote direction: VoteDirection, comment: Comment)
    func commentTableViewCelView(_ commentTableViewCellView: CommentTableViewCellView, comment: Comment, didSelectSaveButton button: ClearButton)
}

final class CommentTableViewCellView: NSView {
    
    private let upvoteDownvoteView: UpvoteDownvoteView = UpvoteDownvoteView()
    private let commentTopView: CommentTopView = CommentTopView()
    private let commentTextLabel: NSTextView = NSTextView()
    let bottomInfoView: PostMetaInfoBottomView = PostMetaInfoBottomView()
    
    static let commentTextLabelFont: NSFont = NSFont.systemFont(ofSize: 13)
    static let upvoteDownvoteViewWidth: CGFloat = 15
    // not best practice...
    var comment: Comment?
    var delegate: CommentTableViewCellViewDelegate?
    
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
    
    func clear() {
        commentTextLabel.textStorage?.setAttributedString(NSAttributedString(string: ""))
        commentTopView.hideScore = nil
        comment = nil
    }
    
    private func commonInit() {
        layoutViews()
        setupViews()
    }
    
    func configure(comment: Comment) {
        self.comment = comment
        
        // vote view configuring
        upvoteDownvoteView.style = .comment
        upvoteDownvoteView.voteLabel.alphaValue = 0
        upvoteDownvoteView.configure(voteCount: comment.data.score ?? 1, hideScore: true, likes: comment.data.likes)
        upvoteDownvoteView.voteLabel.removeFromSuperview()
        
        // comment top view
        commentTopView.configure(comment: comment)
        
        // bottom view
        bottomInfoView.configure(comment: comment)
        
        // comment body
        let doc = CMDocument(string: comment.data.body ?? "-", options: CMDocumentOptions.hardBreaks)
        let renderer = CMAttributedStringRenderer(document: doc, attributes: CMTextAttributes())
        commentTextLabel.textStorage?.setAttributedString(renderer!.render())
        
        bottomInfoView.delegate = self
        commentTextLabel.font = CommentTableViewCellView.commentTextLabelFont
        
        let textColor: NSColor = (comment.data.new ?? false) ? NSColor.controlAccentColor : NSColor.textColor
        commentTextLabel.textColor = textColor
    }
}

extension CommentTableViewCellView: PostMetaInfoBottomViewDelegate {
    func postMetaInfoBottomView(_ postMetaInfoBottomView: PostMetaInfoBottomView, didSelectViewComments button: ClearButton) {
        if !SessionManager.shared.isLoggedIn { return }
        guard let unwrappedComment = comment else { return }
        delegate?.commentTableViewCellView(self, didSelectReply: unwrappedComment)
    }
    
    func postMetaInfoBottomView(_ postMetaInfoBottomView: PostMetaInfoBottomView, didSelectSave button: ClearButton) {
        guard let unwrappedComment = comment else { return }
        delegate?.commentTableViewCelView(self, comment: unwrappedComment, didSelectSaveButton: button)
    }
    
    func postMetaInfoBottomView(_ postMetaInfoBottomView: PostMetaInfoBottomView, didSelectShare button: ClearButton) { }
}

extension CommentTableViewCellView: UpvoteDownvoteViewDelegate {
    
    func didPressVote(_ upvoteDownvoteView: UpvoteDownvoteView, direction: VoteDirection) {
        guard let unwrappedComment = comment, SessionManager.shared.isLoggedIn else { return }
        delegate?.commentTableViewCellView(self, didVote: direction, comment: unwrappedComment)
        
        commentTopView.vote(direction: direction, currentDirection: upvoteDownvoteView.state)
    }
}

extension CommentTableViewCellView {
    
    // width is width of the commentTextLabel
    static func height(comment: Comment, forWidth width: CGFloat) -> CGFloat {
        let topViewMetaHeight: CGFloat = LinkCellConstants.postMetaViewHeight
        let bottomInfoViewHeight: CGFloat = LinkCellConstants.postMetaViewHeight
        
        let doc = CMDocument(string: comment.data.body ?? "-", options: CMDocumentOptions.hardBreaks)
        let renderer = CMAttributedStringRenderer(document: doc, attributes: CMTextAttributes())
        
        let dummyTextField: NSTextView = NSTextView()
        dummyTextField.isEditable = false
        let commentBodyHeight = dummyTextField.bestHeight(for: renderer!.render(), width: width - CommentTableViewCellView.upvoteDownvoteViewWidth, font: CommentTableViewCellView.commentTextLabelFont)
        
        return topViewMetaHeight + bottomInfoViewHeight + commentBodyHeight + 5 + 5
    }
}

extension CommentTableViewCellView {
    
    private func setupViews() {
        commentTextLabel.isEditable = false
        commentTextLabel.font = CommentTableViewCellView.commentTextLabelFont
        commentTextLabel.drawsBackground = false
        
        upvoteDownvoteView.delegate = self
    }
    
    private func layoutViews() {
        commentTopView.setupForAutolayout(superView: self)
        commentTextLabel.setupForAutolayout(superView: self)
        bottomInfoView.setupForAutolayout(superView: self)
        upvoteDownvoteView.setupForAutolayout(superView: self)
        
        upvoteDownvoteView.leadingAnchor.constraint(equalTo: leadingAnchor).activate()
        upvoteDownvoteView.topAnchor.constraint(equalTo: topAnchor, constant: 3.5).activate()
        upvoteDownvoteView.widthAnchor.constraint(equalToConstant: CommentTableViewCellView.upvoteDownvoteViewWidth).activate()
        upvoteDownvoteView.heightAnchor.constraint(equalToConstant: 25).activate()
        
        commentTopView.leadingAnchor.constraint(equalTo: upvoteDownvoteView.trailingAnchor).activate()
        commentTopView.trailingAnchor.constraint(equalTo: trailingAnchor).activate()
        commentTopView.topAnchor.constraint(equalTo: topAnchor).activate()
        commentTopView.heightAnchor.constraint(equalToConstant: LinkCellConstants.postMetaViewHeight).activate()
        
        commentTextLabel.leadingAnchor.constraint(equalTo: commentTopView.leadingAnchor).activate()
        commentTextLabel.topAnchor.constraint(equalTo: commentTopView.bottomAnchor, constant: 5).activate()
        commentTextLabel.trailingAnchor.constraint(equalTo: trailingAnchor).activate()
        commentTextLabel.bottomAnchor.constraint(equalTo: bottomInfoView.topAnchor, constant: -5).activate()
        
        bottomInfoView.leadingAnchor.constraint(equalTo: commentTopView.leadingAnchor).activate()
        bottomInfoView.trailingAnchor.constraint(equalTo: trailingAnchor).activate()
        bottomInfoView.bottomAnchor.constraint(equalTo: bottomAnchor).activate()
        bottomInfoView.heightAnchor.constraint(equalToConstant: LinkCellConstants.postMetaViewHeight).activate()
    }
}
