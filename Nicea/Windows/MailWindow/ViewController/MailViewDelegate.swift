//
//  MailViewDelegate.swift
//  Nicea
//
//  Created by Stephen Bodnar on 4/16/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import AppKit
import APIClient

final class MailViewDelegate: NSObject, NSOutlineViewDelegate {
    
    private let dataSource: MailViewDataSource
    private weak var cellDelegate: CommentTableViewCellViewDelegate?
    private weak var textBoxCellDelegate: CommentTextBoxDelegate?
    
    init(dataSource: MailViewDataSource, cellDelegate: CommentTableViewCellViewDelegate, textBoxCellDelegate: CommentTextBoxDelegate) {
        self.dataSource = dataSource
        self.cellDelegate = cellDelegate
        self.textBoxCellDelegate = textBoxCellDelegate
    }
    
    func outlineView(_ outlineView: NSOutlineView, shouldExpandItem item: Any) -> Bool {
        return true
    }
    
    func outlineView(_ outlineView: NSOutlineView, shouldShowOutlineCellForItem item: Any) -> Bool {
        return false
    }
    
    func outlineView(_ outlineView: NSOutlineView, heightOfRowByItem item: Any) -> CGFloat {
        if let comment = item as? Comment {
            if comment.kind == CommentKind.inProgress {
                return LayoutConstants.commentTextBoxContainerHeight
            } else {
                let defaultWidth: CGFloat = LayoutConstants.mailOutlineViewWidth
                let cellWidth: CGFloat = defaultWidth - 20 // subtract 20 because NSOutlineView content is inset by 20 to account for the expand carat
                return MailTableViewCell.height(comment: comment, width: cellWidth)
            }
        }
        
        return 30
    }

    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        let cell: NSView? = TableViewCells.mailCell(outlineView, viewFor: tableColumn, item: item)
        (cell as? CommentTextBoxCell)?.delegate = textBoxCellDelegate
        (cell as? MailTableViewCell)?.commentView.delegate = cellDelegate
        return cell
    }
}
