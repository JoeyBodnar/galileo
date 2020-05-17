//
//  PostDetailViewModelDelegate.swift
//  Nicea
//
//  Created by Stephen Bodnar on 5/1/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import AppKit
import APIClient

protocol PostDetailViewModelDelegate: AnyObject {
    func postDetailViewModel(_ postDetailViewModel: PostDetailViewModel, didRetrieveComments commentResponse: [Comment])
    func postDetailViewModel(_ postDetailViewModel: PostDetailViewModel, insertItemAtIndex index: IndexSet, forParent parent: Comment)
    func postDetailViewModel(_ postDetailViewModel: PostDetailViewModel, didSelectCancel comment: Comment)
    
    /// called for submitting comment on another comment
    func postDetailViewModel(_ postDetailViewModel: PostDetailViewModel, didSelectSubmit comment: Comment, commentTextBox: CommentTextBoxCell)
    
    /// called when you successfully reply to another comment
    func postDetailViewModel(_ postDetailViewModel: PostDetailViewModel, didReplyToComment comment: Comment, withNewComment newComment: Comment)
    
    /// called when you successfully reply to the parent link
    func postDetailViewModel(_ postDetailViewModel: PostDetailViewModel, didReplyToLink link: Link, withNewComment newComment: Comment)
    
    func postDetailViewModel(_ postDetailViewModel: PostDetailViewModel, didSelectBackButton sender: NSButton)
    func postDetailViewModel(_ postDetailViewModel: PostDetailViewModel, didVoteOnComment comment: Comment, direction: VoteDirection, result: Result<Bool, Error>)
}
