//
//  CommentTextBoxCell.swift
//  Nicea
//
//  Created by Stephen Bodnar on 4/17/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import AppKit
import APIClient

protocol CommentTextBoxDelegate: AnyObject {
    
    func commentTextBoxCell(_ commentTextBox: CommentTextBoxCell, didSelectSubmit comment: Comment?)
    func commentTextBoxCell(_ commentTextBox: CommentTextBoxCell, didSelectCancel comment: Comment)
}

final class CommentTextBoxCell: NSTableCellView {
    private let textView: NSTextView = NSTextView()
    private let cancelButton: GreyButton = GreyButton()
    private let submitButton: ControlAccentColorButton = ControlAccentColorButton()
    
    weak var delegate: CommentTextBoxDelegate?
    
    private var textViewHeightConstraint: NSLayoutConstraint = NSLayoutConstraint()
    private let indicatorBox: NSView = NSView()
    private let indicator: NSActivityIndicator = NSActivityIndicator()
    
    /// the Comment object (of type "in-progress") for this box
    var comment: Comment?
    
    var text: String {
        return textView.string
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layoutViews()
        setupViews()
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        layoutViews()
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func clear() {
        textView.string = ""
        comment = nil
        indicator.alphaValue = 0
        indicator.stopAnimation(nil)
        submitButton.alphaValue = 1
    }
    
    func configure(comment: Comment) {
        self.comment = comment
    }
    
    @objc func submitPressed() {
        if !SessionManager.shared.isLoggedIn || textView.string == "" { return }
        if let unwrappedComment = comment {
            hideSubmitAndStartLoadingIndicator()
            delegate?.commentTextBoxCell(self, didSelectSubmit: unwrappedComment)
        } else {
            hideSubmitAndStartLoadingIndicator()
            delegate?.commentTextBoxCell(self, didSelectSubmit: nil)
        }
    }
    
    private func hideSubmitAndStartLoadingIndicator() {
        submitButton.alphaValue = 0
        indicator.alphaValue = 1
        indicator.startAnimation(self)
    }
    
    @objc func cancelPressed() {
        guard let unwrappedComment = comment else { return }
        delegate?.commentTextBoxCell(self, didSelectCancel: unwrappedComment)
    }
}

extension CommentTextBoxCell: NSTextViewDelegate {
    
    // TODO: finish cache sestup
    func textDidChange(_ notification: Notification) {
        /*guard let textView = notification.object as? NSTextView else { return }
        if textView.string.isEmpty, let unwrappedId = id {
            CommentReplyCache.shared.removeValue(forKey: unwrappedId)
        } else if textView.string.count > 0, let unwrappedId = id {
            CommentReplyCache.shared.setValue(textView.string, forKey: unwrappedId)
        }*/
    }
}

extension CommentTextBoxCell {
    
    private func setupViews() {
        textView.wantsLayer = true
        textView.layer?.cornerRadius = 4
        textView.drawsBackground = true
        textView.layer?.backgroundColor = NSColor.lightGray.cgColor
        textView.delegate = self
        textView.isAutomaticLinkDetectionEnabled = true
        textView.isRichText = true
        textView.isAutomaticDataDetectionEnabled = true
        
        submitButton.title = "submit"
        submitButton.font = NSFont.systemFont(ofSize: 13, weight: .medium)
        submitButton.contentTintColor = NSColor.white
        submitButton.target = self
        submitButton.action = #selector(submitPressed)
        
        cancelButton.title = "cancel"
        cancelButton.font = NSFont.systemFont(ofSize: 13, weight: .medium)
        cancelButton.contentTintColor = NSColor.white
        cancelButton.target = self
        cancelButton.action = #selector(cancelPressed)
        
        indicatorBox.wantsLayer = true
        indicatorBox.layer?.backgroundColor = NSColor.controlAccentColor.cgColor
        indicatorBox.layer?.cornerRadius = 4
    }
    
    private func layoutViews() {
        textView.setupForAutolayout(superView: self)
        cancelButton.setupForAutolayout(superView: self)
        
        indicatorBox.setupForAutolayout(superView: self)
        indicator.setupForAutolayout(superView: indicatorBox)
        submitButton.setupForAutolayout(superView: self)
        
        indicator.center(in: indicatorBox)
        
        textView.leadingAnchor.constraint(equalTo: leadingAnchor).activate()
        textView.topAnchor.constraint(equalTo: topAnchor).activate()
        textView.trailingAnchor.constraint(equalTo: trailingAnchor).activate()
        textViewHeightConstraint = textView.heightAnchor.constraint(equalToConstant: LayoutConstants.commentTextViewHeight)
        textViewHeightConstraint.activate()
        
        submitButton.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 6).activate()
        submitButton.trailingAnchor.constraint(equalTo: trailingAnchor).activate()
        submitButton.heightAnchor.constraint(equalToConstant: LayoutConstants.commentTextBoxSubmitButtonHeight).activate()
        submitButton.widthAnchor.constraint(equalToConstant: 102).activate()
        
        indicatorBox.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 7).activate()
        indicatorBox.trailingAnchor.constraint(equalTo: trailingAnchor).activate()
        indicatorBox.heightAnchor.constraint(equalToConstant: LayoutConstants.commentTextBoxSubmitButtonHeight).activate()
        indicatorBox.widthAnchor.constraint(equalToConstant: 102).activate()
        
        cancelButton.centerYAnchor.constraint(equalTo: submitButton.centerYAnchor).activate()
        cancelButton.trailingAnchor.constraint(equalTo: submitButton.leadingAnchor, constant: -20).activate()
        cancelButton.heightAnchor.constraint(equalToConstant: LayoutConstants.commentTextBoxSubmitButtonHeight).activate()
        cancelButton.widthAnchor.constraint(equalToConstant: 102).activate()
    }
}
