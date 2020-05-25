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
    @IBOutlet weak var textView: NSTextView!
    @IBOutlet weak var cancelButton: GreyButton!
    @IBOutlet weak var submitButton: ControlAccentColorButton!
    @IBOutlet weak var indicator: NSActivityIndicator!
    
    weak var delegate: CommentTextBoxDelegate?
    
    /// the Comment object (of type "in-progress") for this box
    var comment: Comment?
    
    var text: String {
        return textView.string
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
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
        
        indicator.alphaValue = 0
    }
    
    private func layoutViews() {
        
    }
}
