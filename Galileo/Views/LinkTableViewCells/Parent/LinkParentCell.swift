//
//  LinkParentCell.swift
//  Nicea
//
//  Created by Stephen Bodnar on 4/3/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import AppKit
import APIClient

protocol LinkArticleCellDelegate: AnyObject {
    
    func linkArticleCell(_ linkArticleCell: LinkArticleCell, didSelectLink button: ClearButton)
}

protocol LinkParentCellDelegate: AnyObject {
    func linkParentCell(_ linkParentCell: LinkParentCell, didPressVote upvoteDownvoteView: UpvoteDownvoteView, direction: VoteDirection)
    func linkParentCell(_ linkParentCell: LinkParentCell, postMetaBottomView: PostMetaInfoBottomView, didSelectViewComments button: ClearButton)
    func linkParentCell(_ linkParentCell: LinkParentCell, didPressSave button: ClearButton)
    func linkParentCell(_ linkParentCell: LinkParentCell, didSelectImage image: NSImage)
    func linkParentCell(_ linkParentCell: LinkParentCell, didSelectShare button: ClearButton)
}

class LinkParentCell: NSTableCellView {
    
    let upvoteDownvoteView: UpvoteDownvoteView = UpvoteDownvoteView()
    let postMetaInfoView: PostMetaInfoView = PostMetaInfoView()
    let postMetaInfoBottomView: PostMetaInfoBottomView = PostMetaInfoBottomView()
    
    let titleLabel: LinkTitleLabel = LinkTitleLabel()
    
    weak var delegate: LinkParentCellDelegate?
    weak var linkArticleDelegate: LinkArticleCellDelegate?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.stringValue = ""
        upvoteDownvoteView.delegate = nil
        upvoteDownvoteView.voteCount = -10000000
        upvoteDownvoteView.hideScore = nil
        postMetaInfoBottomView.delegate = nil
    }
    
    func configure(link: Link) {
        upvoteDownvoteView.delegate = self
        upvoteDownvoteView.configure(voteCount: link.data.score, hideScore: link.data.hide_score, likes: link.data.likes)
        
        postMetaInfoView.configure(link: link)
        
        titleLabel.stringValue = link.data.title
        titleLabel.preferredMaxLayoutWidth = titleLabel.frame.width
        
        postMetaInfoBottomView.delegate = self
        postMetaInfoBottomView.configure(link: link)
    }
}

extension LinkParentCell: PostMetaInfoBottomViewDelegate {
    
    func postMetaInfoBottomView(_ postMetaInfoBottomView: PostMetaInfoBottomView, didSelectViewComments button: ClearButton) {
        delegate?.linkParentCell(self, postMetaBottomView: postMetaInfoBottomView, didSelectViewComments: button)
    }
    
    func postMetaInfoBottomView(_ postMetaInfoBottomView: PostMetaInfoBottomView, didSelectSave button: ClearButton) {
        delegate?.linkParentCell(self, didPressSave: button)
    }
    
    func postMetaInfoBottomView(_ postMetaInfoBottomView: PostMetaInfoBottomView, didSelectShare button: ClearButton) {
        delegate?.linkParentCell(self, didSelectShare: button)
    }
}

extension LinkParentCell: UpvoteDownvoteViewDelegate {
    
    func didPressVote(_ upvoteDownvoteView: UpvoteDownvoteView, direction: VoteDirection) {
        delegate?.linkParentCell(self, didPressVote: upvoteDownvoteView, direction: direction)
    }
}

