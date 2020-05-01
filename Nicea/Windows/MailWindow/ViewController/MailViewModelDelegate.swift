//
//  MailViewModelDelegate.swift
//  Nicea
//
//  Created by Stephen Bodnar on 4/18/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import Foundation
import APIClient

protocol MailViewModelDelegate: AnyObject {
    
    func mailViewModel(_ mailViewModel: MailViewModel, didRetrieveMailbox comments: [Comment])
    
    /// `newComment` is the comment the user just created. `comment` is the one they replied to
    func mailViewModel(_ mailViewModel: MailViewModel, didRespondToComment comment: Comment, withNewComment newComment: Comment, inCommentBox commentBox: CommentTextBoxCell?)
    /// the comment passed back is the one the user tried to response to
    func mailViewModel(_ mailViewModel: MailViewModel, didFailToRespondToComment comment: Comment, error: Error)
    
    /// the comments passed back are the comments that were marked read
    func mailViewModel(_ mailViewModel: MailViewModel, didMarkCommentsRead comments: [Comment])
    func mailViewModel(_ mailViewModel: MailViewModel, didFailToMarkCommentsRead error: Error)
}
