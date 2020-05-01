//
//  CommentCell.swift
//  Nicea
//
//  Created by Stephen Bodnar on 4/4/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import AppKit
import APIClient

final class CommentCell: NSTableCellView {
    let contentView: CommentTableViewCellView = CommentTableViewCellView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.setupForAutolayout(superView: self)
        contentView.pinToSides(superView: self)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        contentView.clear()
    }
    
    func configure(comment: Comment) {
        contentView.configure(comment: comment)
    }
}

extension CommentCell {
    
    static func height(comment: Comment, width: CGFloat) -> CGFloat {
        return CommentTableViewCellView.height(comment: comment, forWidth: width)
    }
}
