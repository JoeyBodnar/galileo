//
//  LayoutConstants.swift
//  Nicea
//
//  Created by Stephen Bodnar on 4/17/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import AppKit

struct LinkCellConstants {
    static let voteViewSize: NSSize = NSSize(width: 40, height: 65)
    static let postMetaViewHeight: CGFloat = 22
    
    // for video, image cells. spacing between media top and title bottom
    static let mediaContentSpacingToTitle: CGFloat = 8
    static let urlLinkTopToTitleBottom: CGFloat = 10
    static let urlLinkTextHeight: CGFloat = 12
    
    static let titleLabelFont: NSFont = NSFont.boldSystemFont(ofSize: 15)
}

struct LayoutConstants {
    
    // Fonts
    static let mailTitleFont: NSFont = NSFont.systemFont(ofSize: 13, weight: .bold)
    static let flairFont: NSFont = NSFont.systemFont(ofSize: 14, weight: .bold)
    
    // Window
    
    /// the default size for the main window
    static let defaultMainWindowRect: NSRect = NSRect(x: 0, y: 0, width: 1000, height: 650)
    
    static let defaultWebViewWindowRect: NSRect = NSRect(x: 0, y: 0, width: 900, height: 650)
    static let defaultPhotoViewerWindowRect: NSRect = NSRect(x: 0, y: 0, width: 650, height: 500)
    static let mailWindowControllerDefaultRect: NSRect = NSRect(x: 0, y: 0, width: 750, height: 500)
    
    static let mailTableViewInsets: NSEdgeInsets = NSEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    static let mailTableViewCellInsets: NSEdgeInsets = NSEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
    static let mailTableViewCellTitleTopSpacing: CGFloat = 6
    
    static var mailOutlineViewWidth: CGFloat {
        return mailWindowControllerDefaultRect.width - (mailTableViewInsets.left + mailTableViewInsets.right) - (mailTableViewCellInsets.left + mailTableViewCellInsets.right)
    }
    
    /// the height of the comment textview inside the comment box. the actual comment box that contains it is > 80
    static let commentTextViewHeight: CGFloat = 130
    /// the height of the submit and cancel buttons in the comment box
    static let commentTextBoxSubmitButtonHeight: CGFloat = 30
    /// the height of the entire comment box, including buttons
    static var commentTextBoxContainerHeight: CGFloat {
        return commentTextViewHeight + commentTextBoxSubmitButtonHeight + 10 // 10 is padding
    }
    
    /// the width of the outlineview on for PostDetail
    static let postDetailOutlineViewWidth: CGFloat = 700
    
    /// the height of the entire subreddit header
    static let subredditHeaderCellHeight: CGFloat = 130
    /// the height of the top color bar of the subreddit header
    static let subredditHeaderCellTopViewHeight: CGFloat = 50
}
