//
//  PostListDelegate.swift
//  Nicea
//
//  Created by Stephen Bodnar on 4/6/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import AppKit
import APIClient

final class PostListDelegate: NSObject, NSTableViewDelegate {
    
    let dataSource: PostListDataSource
    
    private let cellDelegate: LinkParentCellDelegate
    private let headerDelegate: SubredditHeaderCellDelegate
    private let linkArticleDelegate: LinkArticleCellDelegate
    
    init(dataSource: PostListDataSource, cellDelegate: LinkParentCellDelegate, headerDelegate: SubredditHeaderCellDelegate, linkArticleDelegate: LinkArticleCellDelegate) {
        self.dataSource = dataSource
        self.cellDelegate = cellDelegate
        self.headerDelegate = headerDelegate
        self.linkArticleDelegate = linkArticleDelegate
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        if dataSource.posts.indices.contains(row) {
            if let post = dataSource.posts[row] as? Link {
                return TableViewCellHeights.linkCellHeight(tableView, link: post, heightOfRow: row)
            } else {
                return LayoutConstants.subredditHeaderCellHeight // size for header here
            }
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if dataSource.posts.indices.contains(row) {
            if let link = dataSource.posts[row] as? Link {
                let view: NSView? = TableViewCells.linkCell(tableView, link: link, viewFor: tableColumn, row: row)
                (view as? LinkParentCell)?.delegate = cellDelegate
                (view as? LinkArticleCell)?.linkArticleDelegate = linkArticleDelegate
                return view
            } else if let subreddit = dataSource.posts[row] as? Subreddit {
                let view: SubredditHeaderCell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: CellIdentifiers.SubredditHeaderCell), owner: self) as! SubredditHeaderCell
                view.delegate = headerDelegate
                if let del = headerDelegate as? PostListViewController {
                    view.configure(subreddit: subreddit, sort: del.viewModel.currentSort)
                }
                return view
            } // used for Home, Popular, and All
            else if let redditDefaultFeedItem = dataSource.posts[row] as? String {
                let view: SubredditHeaderCell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: CellIdentifiers.SubredditHeaderCell), owner: self) as! SubredditHeaderCell
                view.delegate = headerDelegate
                if let del = headerDelegate as? PostListViewController {
                    view.configure(defaultFeedItem: redditDefaultFeedItem, sort: del.viewModel.currentSort)
                }
                return view
            }
        }
        
        return nil
    }
}
