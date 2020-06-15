//
//  MailViewModelDelegate.swift
//  Nicea
//
//  Created by Stephen Bodnar on 4/18/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import Foundation
import APIClient

protocol CommentListViewModelDelegate: AnyObject {
    
    func commentListViewModel(_ commentListViewModel: CommentListViewModel, didRetrieveMailbox comments: [Comment])
    
    /// `newComment` is the comment the user just created. `comment` is the one they replied to
    func commentListViewModel(_ commentListViewModel: CommentListViewModel, didRespondToComment comment: Comment, withNewComment newComment: Comment, inCommentBox commentBox: CommentTextBoxCell?)
    /// the comment passed back is the one the user tried to response to
    func commentListViewModel(_ commentListViewModel: CommentListViewModel, didFailToRespondToComment comment: Comment, error: Error)
    
    /// the comments passed back are the comments that were marked read
    func commentListViewModel(_ commentListViewModel: CommentListViewModel, didMarkCommentsRead comments: [Comment])
    func commentListViewModel(_ commentListViewModel: CommentListViewModel, didFailToMarkCommentsRead error: Error)
}
