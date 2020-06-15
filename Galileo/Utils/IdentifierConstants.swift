//
//  IdentifierConstants.swift
//  Nicea
//
//  Created by Stephen Bodnar on 3/27/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import Foundation

struct StoryboardIds {
    
    static let Main: String = "Main"
    static let AuthenticationWindowController: String = "AuthenticationWindowController"
    static let CommentListWindowController: String = "CommentListWindowController"
    static let MainWindowController: String = "MainWindowController"
}

struct CommentKind {
    
    static let inProgress: String = "in-progress"
}

// If one of these are changed, don't forget to also change in the storyboard
struct CellIdentifiers {
    
    static let LinkArticleCell: String = "LinkArticleCell"
    static let LinkImageCell: String = "LinkImageCell"
    static let LinkVideoCell: String = "LinkVideoCell"
    static let SidebarSubredditCell: String = "SidebarSubredditCell"
    static let SubredditHeaderCell: String = "SubredditHeaderCell"
    static let SidebarSectionHeaderCell: String = "SidebarSectionHeaderCell"
    static let CommentLoadingCell: String = "CommentLoadingCell"
    static let CommentTextBoxCell: String = "CommentTextBoxCell"
    static let CommentCell: String = "CommentCell"
    static let MailTableViewCell: String = "MailTableViewCell"
}

struct ImageNames {
    
    static let subredditIconDefault: String = "subredditIconDefault"
    static let chevronUp: String = "chevronUp"
    static let chevronDown: String = "chevronDown"
    static let play: String = "play"
    static let trending: String = "trending"
    static let mailFill: String = "mail-fill"
    static let home: String = "home"
}
