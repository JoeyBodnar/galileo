//
//  Comment+Extension.swift
//  Nicea
//
//  Created by Stephen Bodnar on 4/17/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import AppKit
import APIClient

extension Comment {
    
    /// in the Mail window, to show replies in your inbox the format is like:
    /// comment reply: <Insert original link title here>
    /// the flairText here refers to "comment reply", although it can also be an automated message by a bot or PM as well
    var attributedTextForMailTitle: NSAttributedString? {
        guard let linkTitle = data.linkTitle else { return nil }
        let isNew = data.new ?? false
        let color = isNew ? NSColor.controlAccentColor : NSColor.textColor
        let attributedTitle = NSMutableAttributedString(string: linkTitle,  attributes: [NSAttributedString.Key.font: LayoutConstants.mailTitleFont, NSAttributedString.Key.foregroundColor: color])
        
        if let flairText = data.subject {
            let flairAttributedString = NSMutableAttributedString(string: "\(flairText)  ", attributes: [NSAttributedString.Key.font: LayoutConstants.flairFont, NSAttributedString.Key.foregroundColor: NSColor.controlAccentColor])
            flairAttributedString.append(attributedTitle)
            return flairAttributedString
        } else {
            return attributedTitle
        }
    }
    
    var isInProgressComment: Bool {
        return kind == CommentKind.inProgress
    }
}
