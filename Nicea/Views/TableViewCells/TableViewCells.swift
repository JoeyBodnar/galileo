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
    
    static func sideBarItemCell(_ outlineView: NSOutlineView, item: SidebarItem, viewFor tableColumn: NSTableColumn?) -> NSView? {
        switch item {
        case .trendingSubreddit(let name, let imageName):
            return sidebarTrendingSubredditCell(outlineView, text: name, imageName: imageName, viewFor: tableColumn)
        case .subscriptionSubreddit(let subreddit):
            return sidebarSubredditCell(outlineView, subreddit: subreddit, viewFor: tableColumn)
        case .search:
            return searchCell(outlineView, viewFor: tableColumn)
        case .searchOptions:
            return searchOptionsCell(outlineView, viewFor: tableColumn)
        case .defaultRedditFeed(let name, let imageName):
            return sidebarTrendingSubredditCell(outlineView, text: name, imageName: imageName, viewFor: tableColumn)
        }
    }
    
    static func sidebarSubredditCell(_ outlineView: NSOutlineView, subreddit: Subreddit, viewFor tableColumn: NSTableColumn?) -> NSView? {
        let view = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: CellIdentifiers.SidebarSubredditCell), owner: self) as? SidebarSubredditCell
        view?.wantsLayer = true
        view?.configure(subreddit: subreddit)
        return view
    }
    
    static func sidebarTrendingSubredditCell(_ outlineView: NSOutlineView, text: String, imageName: String, viewFor tableColumn: NSTableColumn?) -> NSView? {
        let view = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: CellIdentifiers.SidebarSubredditCell), owner: self) as? SidebarSubredditCell
        view?.wantsLayer = true
        view?.configure(subreddit: text, imageName: imageName)
        return view
    }
    
    static func searchOptionsCell(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?) -> NSView? {
        let view: SidebarSearchToggleCell? = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier("SidebarSearchToggleCell"), owner: self) as? SidebarSearchToggleCell
        return view
    }
    
    static func searchCell(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?) -> NSView? {
        let view: SidebarSearchCell? = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier("SidebarSearchCell"), owner: self) as? SidebarSearchCell
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
            let view: LinkArticleCell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: CellIdentifiers.LinkArticleCell), owner: self) as! LinkArticleCell
            view.wantsLayer = true
            view.configure(link: link)
            return view
        case .imageReddit, .imageImgur, .gifImgur:
            let view: LinkImageCell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: CellIdentifiers.LinkImageCell), owner: self) as! LinkImageCell
            view.wantsLayer = true
            view.configure(link: link)
            return view
        case .hostedVideo, .youtubeVideo, .gyfcatVideo, .richVideoGeneric:
            let view: LinkVideoCell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: CellIdentifiers.LinkVideoCell), owner: self) as! LinkVideoCell
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
    
    static func postListTableViewCell(_ tableView: NSTableView, item: Any, sort: MenuSortItem, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if let link = item as? Link {
            let view: NSView? = TableViewCells.linkCell(tableView, link: link, viewFor: tableColumn, row: row)
            return view
        } else if let redditDefaultFeedItem = item as? PostListHeaderCellType {
            let view: SubredditHeaderCell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: CellIdentifiers.SubredditHeaderCell), owner: self) as! SubredditHeaderCell
            switch redditDefaultFeedItem {
            case .defaultRedditFeed(let name):
                view.configure(defaultFeedItem: name, sort: sort)
            case .subreddit(let subreddit):
                view.configure(subreddit: subreddit, sort: sort)
            default: break
            }
            return view
        }
        
        
        return nil
    }
}
