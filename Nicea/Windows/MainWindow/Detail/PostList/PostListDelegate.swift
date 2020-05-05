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
    private let viewModel: PostListViewModel
    
    init(dataSource: PostListDataSource, cellDelegate: LinkParentCellDelegate, headerDelegate: SubredditHeaderCellDelegate, linkArticleDelegate: LinkArticleCellDelegate, viewModel: PostListViewModel) {
        self.dataSource = dataSource
        self.cellDelegate = cellDelegate
        self.headerDelegate = headerDelegate
        self.linkArticleDelegate = linkArticleDelegate
        self.viewModel = viewModel
    }
    
    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        if row == 0, let headerView = tableView.view(atColumn: 0, row: row, makeIfNecessary: false) as? SubredditHeaderCell {
            headerView.goToSubredditField.becomeFirstResponder()
        }
        
        return false
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
            let cell: NSView? = TableViewCells.postListTableViewCell(tableView, item: dataSource.posts[row], sort: viewModel.currentSort, viewFor: tableColumn, row: row)
            (cell as? LinkParentCell)?.delegate = cellDelegate
            (cell as? LinkArticleCell)?.linkArticleDelegate = linkArticleDelegate
            (cell as? SubredditHeaderCell)?.delegate = headerDelegate
            return cell
        }
        
        return nil
    }
}
