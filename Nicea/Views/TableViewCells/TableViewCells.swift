//
//  TableViewCells.swift
//  Nicea
//
//  Created by Stephen Bodnar on 3/27/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import AppKit
import APIClient

final class TableViewCells {
    
    static func sidebarSubredditCell(_ outlineView: NSOutlineView, subreddit: Subreddit, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        let view = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: CellIdentifiers.SidebarSubredditCell), owner: self) as? SidebarSubredditCell
        view?.wantsLayer = true
        view?.configure(subreddit: subreddit)
        return view
    }
    
    static func sidebarTrendingSubredditCell(_ outlineView: NSOutlineView, text: String, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        let view = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: CellIdentifiers.SidebarSubredditCell), owner: self) as? SidebarSubredditCell
        view?.wantsLayer = true
        view?.configure(trendingSubreddit: text)
        return view
    }
    
    static func sidebarDefaultRedditFeedCell(_ outlineView: NSOutlineView, defaultfeedItem: SidebarDefaultItem, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        let view = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: CellIdentifiers.SidebarSubredditCell), owner: self) as? SidebarSubredditCell
        view?.wantsLayer = true
        view?.configure(defaultFeedItem: defaultfeedItem)
        return view
    }
    
    static func sidebarSectionHeaderCell(_ outlineView: NSOutlineView, text: String, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        let view = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: CellIdentifiers.SidebarSectionHeaderCell), owner: self) as? SidebarSectionHeaderCell
        view?.wantsLayer = true
        view?.label.stringValue = text
        
        return view
    }
    
    static func linkCell(_ tableView: NSTableView, link: Link, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let linkType: LinkType = LinkType(link: link)
        switch linkType {
        case .linkedArticle, .selfText:
            let view = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: CellIdentifiers.LinkArticleCell), owner: self) as! LinkArticleCell
            view.wantsLayer = true
            view.configure(link: link)
            return view
        case .imageReddit, .imageImgur, .gifImgur:
            let view = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: CellIdentifiers.LinkImageCell), owner: self) as! LinkImageCell
            view.wantsLayer = true
            view.configure(link: link)
            return view
        case .hostedVideo, .youtubeVideo, .gyfcatVideo, .richVideoGeneric:
            let view = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: CellIdentifiers.LinkVideoCell), owner: self) as! LinkVideoCell
            view.wantsLayer = true
            view.configure(link: link)
            return view
        }
    }
    
    static func commentCell(_ outlineView: NSOutlineView, comment: Comment, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        if comment.isMoreItem {
            let loadingCell: CommentLoadingCell = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(CellIdentifiers.CommentLoadingCell), owner: self) as! CommentLoadingCell
            loadingCell.configure(itemCount: comment.data.commentChildren?.count ?? 0)
            return loadingCell
        } else if comment.isInProgressComment {
            let cell: CommentTextBoxCell = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(CellIdentifiers.CommentTextBoxCell), owner: self) as! CommentTextBoxCell
            cell.comment = comment
            return cell
        } else {
            let commentCell: CommentCell = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(CellIdentifiers.CommentCell), owner: self) as! CommentCell
            commentCell.configure(comment: comment)
            return commentCell
        }
    }
    
    static func mailCell(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        if let comment = item as? Comment {
            if comment.kind == CommentKind.inProgress {
                let cell: CommentTextBoxCell = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(CellIdentifiers.CommentTextBoxCell), owner: self) as! CommentTextBoxCell
                cell.comment = comment
                return cell
            } else {
                let cell: MailTableViewCell = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(CellIdentifiers.MailTableViewCell), owner: self) as! MailTableViewCell
                cell.configure(comment: comment, width: outlineView.frame.width - 40)
                return cell
            }
        }
        return nil
    }
}
