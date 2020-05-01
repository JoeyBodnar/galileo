//
//  MailTableViewCell.swift
//  Nicea
//
//  Created by Stephen Bodnar on 4/16/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import AppKit
import APIClient

final class MailTableViewCell: NSTableCellView {
    private let titleButton: NSLabel = NSLabel()
    
    let commentView: CommentTableViewCellView = CommentTableViewCellView()
    
    private var commentViewHeightAnchor: NSLayoutConstraint = NSLayoutConstraint()
    private var titleButtonHeightAnchor: NSLayoutConstraint = NSLayoutConstraint()
    private var titleButtonTopAnchor: NSLayoutConstraint = NSLayoutConstraint()
    
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
        commentView.comment = nil
    }
    
    private func commonInit() {
        layoutViews()
        setupViews()
    }
    
    func configure(comment: Comment, width: CGFloat) {
        if let attrText = comment.attributedTextForMailTitle {
            titleButton.attributedStringValue = attrText
            titleButtonHeightAnchor.constant = titleButton.bestHeight(for: attrText, width: width, font: nil)
            titleButtonTopAnchor.constant = LayoutConstants.mailTableViewCellTitleTopSpacing
        } else {
            titleButton.stringValue = ""
            titleButtonHeightAnchor.constant = 0
            titleButtonTopAnchor.constant = 0
        }
        
        commentView.configure(comment: comment)
        commentViewHeightAnchor.constant = CommentTableViewCellView.height(comment: comment, forWidth: width)
    }
}

extension MailTableViewCell {
        
    static func height(comment: Comment, width: CGFloat) -> CGFloat {
        let dummyTextField: NSTextField = NSTextField()
        dummyTextField.usesSingleLineMode = false
        dummyTextField.isEditable = false
        
        var titleHeight: CGFloat
        var topTitleSpacing: CGFloat = LayoutConstants.mailTableViewCellTitleTopSpacing
        if let attrText = comment.attributedTextForMailTitle {
            titleHeight = dummyTextField.bestHeight(for: attrText, width: width, font: nil)
        } else {
            titleHeight = 0
            topTitleSpacing = 0
        }
        
        let commentViewHeight: CGFloat = CommentTableViewCellView.height(comment: comment, forWidth: width)
        
        return titleHeight + commentViewHeight + topTitleSpacing
    }
}

extension MailTableViewCell {
    
    private func setupViews() {
        wantsLayer = true
        layer?.backgroundColor = NSColor.clear.cgColor
    }
    
    private func layoutViews() {
        titleButton.setupForAutolayout(superView: self)
        commentView.setupForAutolayout(superView: self)

        titleButton.leadingAnchor.constraint(equalTo: leadingAnchor).activate()
        titleButtonTopAnchor = titleButton.topAnchor.constraint(equalTo: topAnchor, constant: LayoutConstants.mailTableViewCellTitleTopSpacing)
        titleButtonTopAnchor.activate()
        titleButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -LayoutConstants.mailTableViewCellInsets.right).activate()
        titleButtonHeightAnchor = titleButton.heightAnchor.constraint(equalToConstant: 18)
        titleButtonHeightAnchor.activate()
        
        commentView.leadingAnchor.constraint(equalTo: titleButton.leadingAnchor).activate()
        commentView.topAnchor.constraint(equalTo: titleButton.bottomAnchor).activate()
        commentView.trailingAnchor.constraint(equalTo: titleButton.trailingAnchor).activate()
        commentViewHeightAnchor = commentView.heightAnchor.constraint(equalToConstant: 50)
        commentViewHeightAnchor.activate()
    }
}

