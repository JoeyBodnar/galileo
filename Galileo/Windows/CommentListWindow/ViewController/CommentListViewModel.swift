//
//  CommentListViewModel.swift
//  Nicea
//
//  Created by Stephen Bodnar on 4/16/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import Foundation
import APIClient

enum CommentListType {
    
    case userProfile(username: String)
    case mailbox
    
    var windowTitle: String {
        switch self {
        case .mailbox: return "Mailbox"
        case .userProfile(username: let username): return username
        }
    }
}

final class CommentListViewModel {
    
    weak var delegate: CommentListViewModelDelegate?
    
    var commentListType: CommentListType = .mailbox {
        didSet {
            getComments()
        }
    }
    
    var windowTitle: String {
        return commentListType.windowTitle
    }
    
    func getComments() {
        switch commentListType {
        case .mailbox: getMailbox()
        case .userProfile(let username): getUserProfile(username: username)
        }
    }
    
    private func getUserProfile(username: String) {
        UserServices.shared.getUserPosts(username: username) { [weak self] result in
            switch result {
            case .success(let userComments):
                guard let weakSelf = self else { return }
                weakSelf.delegate?.commentListViewModel(weakSelf, didRetrieveMailbox: userComments.data?.children ?? [])
            case .failure(let error): print(error)
            }
        }
    }
    
    private func getMailbox() {
        UserServices.shared.getUserMailbox() { [weak self] result in
            switch result {
            case .success(let mailbox):
                guard let weakSelf = self else { return }
                weakSelf.delegate?.commentListViewModel(weakSelf, didRetrieveMailbox: mailbox.data.children ?? [])
            case .failure(let error): print(error)
            }
        }
    }
    
    // need to pass textBoxView because after the comment is successfully created, we need to
    // reset its contents (clear text, reset submit btton)
    func replyToComment(comment: Comment, withText text: String, textBoxView: CommentTextBoxCell?) {
        guard let parentId = comment.data.name, SessionManager.shared.isLoggedIn else { return }
        PostServices.shared.reply(parentId: parentId, text: text) { result in
            switch result {
            case .success(let comments):
                CommentReplyCache.shared.removeValue(forKey: parentId)
                self.delegate?.commentListViewModel(self, didRespondToComment: comment, withNewComment: comments[0], inCommentBox: textBoxView)
            case .failure(let error):
                self.delegate?.commentListViewModel(self, didFailToRespondToComment: comment, error: error)
            }
        }
    }
    
    func markCommentsRead(comments: [Comment]) {
        guard SessionManager.shared.isLoggedIn else { return }
        let newComments: [Comment] = comments.filter { $0.data.new ?? false }
        if newComments.count == 0 { return }
        let ids: [String] = newComments.map { $0.data.name ?? "" }.filter { $0 != "" }
        PostServices.shared.markCommentsRead(ids: ids) { [weak self] result in
            guard let weakSelf = self else { return }
            switch result {
            case .success:
                weakSelf.delegate?.commentListViewModel(weakSelf, didMarkCommentsRead: newComments)
                NotificationCenter.default.post(name: .didReadMail, object: nil)
            case .failure(let error): weakSelf.delegate?.commentListViewModel(weakSelf, didFailToMarkCommentsRead: error)
            }
        }
    }
}
