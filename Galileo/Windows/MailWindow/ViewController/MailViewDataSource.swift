//
//  MailViewDataSource.swift
//  Nicea
//
//  Created by Stephen Bodnar on 4/16/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import AppKit
import APIClient

final class MailViewDataSource: NSObject, NSOutlineViewDataSource {
    
    var items: [Any]
    
    private let commentKindInProgress: String = CommentKind.inProgress
    
    init(comments: [Any]) {
        self.items = comments
    }
    
    @discardableResult
    func insertCommentField(forComment comment: Comment) -> Comment? {
        if parentCommentContainsInProgressComment(comment: comment) {
            print("already contains inprogress-returning")
            return nil
        }
        
        let inProgressComment: Comment = Comment(kind: commentKindInProgress, data: CommentData())
        if let currentReplies = comment.data.replies {
            currentReplies.data?.children?.insert(inProgressComment, at: 0)
        } else {
            let listingResponse: ListingResponse<Comment> = ListingResponse(modhash: nil, before: nil, after: nil, dist: nil, children: [inProgressComment])
            comment.data.replies = CommentReplyData(kind: commentKindInProgress, data: listingResponse)
        }
        
        return inProgressComment
    }
    
    func removeInProgressComment(forComment comment: Comment) {
        comment.data.replies?.data?.children = comment.data.replies?.data?.children?.filter({ comment -> Bool in
            return comment.kind != commentKindInProgress
        })
    }

    private func parentCommentContainsInProgressComment(comment: Comment) -> Bool {
        if let currentReplies = comment.data.replies, let children = currentReplies.data?.children {
            return children.contains { com -> Bool in
                return com.kind == commentKindInProgress
            }
        }
        
        return false
    }
    
    // MARK: - NSOutlineViewDataSource
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        if let comment = item as? Comment {
            if comment.isMoreItem { return true }
            let kidsCount: Int = comment.data.replies?.data?.children?.count ?? 0
            return kidsCount > 0
        }
        
        return true
    }
    
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        if let comment = item as? Comment, let children = comment.data.replies?.data?.children {
            if children.indices.contains(index) {
                return children[index] as Any
            }
        }
        
        return items[index]
    }
    
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        if let comment = item as? Comment {
            return comment.data.replies?.data?.children?.count ?? 0
        }
        
        return items.count
    }
}
