//
//  PostDetailDelegate.swift
//  Nicea
//
//  Created by Stephen Bodnar on 4/6/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import AppKit
import APIClient

final class PostDetailDelegate: NSObject, NSOutlineViewDelegate {
    
    let dataSource: PostDetailDataSource
    weak var viewModel: PostDetailViewModel?
    weak var commentCellDelegate: CommentTableViewCellViewDelegate?
    weak var textBoxDelegate: CommentTextBoxDelegate?
    weak var postDetailHeaderDelegate: PostDetailHeaderCellDelegate?
    
    init(dataSource: PostDetailDataSource, viewModel: PostDetailViewModel, commentCellDelegate: CommentTableViewCellViewDelegate, textBoxDelegate: CommentTextBoxDelegate, postDetailHeaderDelegate: PostDetailHeaderCellDelegate) {
        self.dataSource = dataSource
        self.viewModel = viewModel
        self.commentCellDelegate = commentCellDelegate
        self.textBoxDelegate = textBoxDelegate
        self.postDetailHeaderDelegate = postDetailHeaderDelegate
    }
    
    func outlineViewItemDidExpand(_ notification: Notification) {
        guard let viewModel = viewModel else { return }
        if viewModel.isAutoExpanding { return }
        if let comment = notification.userInfo?["NSObject"] as? Comment, comment.isMoreItem {
            viewModel.loadMoreCommentsOnParentArticle(comment: comment)
            if let outlineView = notification.object as? NSOutlineView {
                let row = outlineView.row(forItem: comment)
                if let rowView = outlineView.rowView(atRow: row, makeIfNecessary: false), let cell = rowView.view(atColumn: 0) as? CommentLoadingCell {
                    cell.startAnimating()
                }
            }
        }
    }
    
    func outlineView(_ outlineView: NSOutlineView, shouldExpandItem item: Any) -> Bool {
        let isAutoExpanding: Bool = viewModel?.isAutoExpanding ?? false
        if let comment = item as? Comment, comment.isMoreItem, isAutoExpanding {
            return false
        }
        
        return true
    }
    
    func outlineView(_ outlineView: NSOutlineView, heightOfRowByItem item: Any) -> CGFloat {
        if let comment = item as? Comment {
            let depth: Int = comment.data.depth ?? 0
            let indentationPerDepth: CGFloat = 15
            let outlineViewWidth: CGFloat = LayoutConstants.postDetailOutlineViewWidth
            let commentTextBoxWidth: CGFloat = outlineViewWidth - (CGFloat(depth) * indentationPerDepth)

            if comment.isMoreItem {
                return 20
            } else if comment.isInProgressComment {
                return LayoutConstants.commentTextBoxContainerHeight
            } else {
                // calculations seem to be a bit off sometimes. Subtract 30 so if there are a few characters on the last line then it wont cut them off
                return CommentCell.height(comment: comment, width: commentTextBoxWidth - 30)
            }
        } else if let link = item as? Link {
            return PostDetailHeaderCell.height(link: link, width: outlineView.frame.width)
        }
        return 30
    }

    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        if let comment = item as? Comment, let cell = TableViewCells.commentCell(outlineView, comment: comment, viewFor: tableColumn, item: item) {
            (cell as? CommentTextBoxCell)?.delegate = textBoxDelegate
            (cell as? CommentCell)?.contentView.delegate = commentCellDelegate
            return cell
        } else if let link = item as? Link {
            let cell: PostDetailHeaderCell = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "PostDetailHeaderCell"), owner: self) as! PostDetailHeaderCell
            cell.delegate = postDetailHeaderDelegate
            cell.configure(link: link, sort: viewModel?.currentSort.rawValue ?? "")
            return cell
        }
        return nil
    }
}
