//
//  PostDetailViewModel.swift
//  Nicea
//
//  Created by Stephen Bodnar on 4/4/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import AppKit
import APIClient

final class PostDetailViewModel {
    
    /// the current subreddit
    var subreddit: String = ""
    
    /// the current link being viewed
    var link: Link?
    
    weak var delegate: PostDetailViewModelDelegate?
    
    let dataSource: PostDetailDataSource = PostDetailDataSource(comments: [])
    
    lazy var outlineViewDelegate: PostDetailDelegate = {
        return PostDetailDelegate(dataSource: dataSource, viewModel: self, commentCellDelegate: self, textBoxDelegate: self, postDetailHeaderDelegate: self)
    }()
    
    /// after loading comments we need to autoexpand some nodes, and during this split second, we suspend normal operations that we would do when manually expanding a node (for example, like loading more comments on node expand. Only want to do that for when a user manually expands a a node)
    var isAutoExpanding: Bool = false
    
    private var parentLinkMoreCommentList: [String] = []
    private let commentLoadMoreLimit: Int = 100
    
    func loadArticleAndComments(for link: Link) {
        PostServices.shared.getComments(subreddit: link.data.subreddit, articleId: link.data.id, isLoggedIn: SessionManager.shared.isLoggedIn) { [weak self] result in
            switch result {
            case .success(let commentResponse):
                self?.handleDidLoadInitialComments(commentResponse: commentResponse, originalLink: link)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func loadMoreCommentsOnParentArticle(comment: Comment) {
        let parentLinkChildrenIds: [String] = Array(parentLinkMoreCommentList.prefix(commentLoadMoreLimit))
        guard let children = comment.data.commentChildren, let parentId = link?.data.name else { return }
        
        let childrenIdsToRetrieve: [String] = comment.isTopLevelComment ? parentLinkChildrenIds : children
        
        PostServices.shared.getMoreComments(subreddit: subreddit, parentId: parentId, childrenIds: childrenIdsToRetrieve) { [weak self] result in
            switch result {
            case .success(let newComments):
                self?.handleDidFetchNewComments(newComments, parentComment: comment)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func handleDidLoadInitialComments(commentResponse: CommentResponse, originalLink: Link) {
        guard let children = commentResponse.data?.children else { return }
        self.dataSource.comments = [originalLink] + children
        
        self.parentLinkMoreCommentList = children.last?.data.commentChildren ?? []
        self.delegate?.postDetailViewModel(self, didRetrieveComments: children)
    }
    
    /// called after successfully fetched new comments from server
    private func handleDidFetchNewComments(_ newComments: [Comment], parentComment: Comment) {
        if parentComment.isTopLevelComment {
            self.addTopLevelComments(newComments, parentId: parentComment.data.parentId!)
        } else {
            let commentSet: [Comment] = dataSource.comments.filter { $0 is Comment } as! [Comment]
            if let realParentComment = self.findCommentWithFullName(parentComment.data.parentId!, commentSet: commentSet) {
                self.assignNewCommentRepliesToParentComment(realParentComment, newComments: newComments)
            }
        }
        self.delegate?.postDetailViewModel(self, didRetrieveComments: newComments)
    }
    
    /// add top level comments to the article. parentId will be `t3_xxxxx` because the parent will be a link
    private func addTopLevelComments(_ comments: [Comment], parentId: String) {
        var commentsOnParentPost: [Comment] = comments.filter { comment -> Bool in
            let matchesParent: Bool = comment.data.parentId! == parentId
            let isTopLevel = comment.isTopLevelComment
            return matchesParent && isTopLevel
        }
        
        print("last comment type from server is \(commentsOnParentPost.last?.kind)")
        // first, remove last comment that is the "load more.." comment
        dataSource.comments.remove(at: dataSource.comments.count - 1)
        
        if commentsOnParentPost.last!.isMoreItem { // then remove
            commentsOnParentPost.removeLast(1)
        }
        
        // then append
        dataSource.comments.append(contentsOf: commentsOnParentPost)
        
        // filter parentLinkMoreCommentList to remove all IDs that were added
        parentLinkMoreCommentList = parentLinkMoreCommentList.filter({ commentId -> Bool in
            return !comments.contains { comment -> Bool in
                return (comment.data.id ?? "") == commentId
            }
        })
        
        //if !commentsOnParentPost.last!.isMoreItem {
            // then create new "load more" comment with new count
            let commentData: CommentData = CommentData()
            commentData.commentChildren = parentLinkMoreCommentList
            commentData.parentId = parentId
            let loadMoreComment: Comment = Comment(kind: "more", data: commentData)

            // then append that comment to the end
            dataSource.comments.append(loadMoreComment)
        //}
        
        // comments not on the parent post, but responding to other comments
        let commentChildren: [Comment] = comments.filter { comment -> Bool in
           let first2: String = String(comment.data.parentId!.prefix(2))
           return first2 == "t1"
        }
        
        let commentSet: [Comment] = dataSource.comments.filter { $0 is Comment } as! [Comment]
        addCommentsToCommentTree(commentSet, newComments: commentChildren, parentId: parentId)
    }
    
    /// add comments that are in response to othere comments to the tree (`parentId` should be format `t1_xxxxx`
    private func addCommentsToCommentTree(_ originalCommentSet: [Comment], newComments: [Comment], parentId: String) {
        for originalComment in originalCommentSet {
            for new in newComments {
                if let originalCommentname = originalComment.data.name {
                    if new.data.parentId == originalCommentname {
                        if let iReplies = originalComment.data.replies { // if already exists, append it
                            iReplies.data?.children?.append(new)
                        } else { // does not exist yet, create new instance
                            let constructedListing: ListingResponse<Comment> = ListingResponse(modhash: nil, before: nil, after: nil, dist: nil, children: [new])
                            let commentReplyData = CommentReplyData(kind: "t1", data: constructedListing)
                            originalComment.data.replies = commentReplyData
                        }
                        
                        addCommentsToCommentTree([new], newComments: newComments, parentId: new.data.name!)
                    }
                }
                
            }
        }
    }
    
    /// accepts a comment and new comment as parameters. It will assign all child comments to the parent comment from the newComments array
    private func assignNewCommentRepliesToParentComment(_ parentComment: Comment, newComments: [Comment]) {
        for newComment in newComments {
            if newComment.data.parentId! == parentComment.data.name! {
                if let existingReplies = parentComment.data.replies { // if already exists, append it
                    existingReplies.data?.children?.append(newComment)
                } else { // does not exist yet, create new instance
                    let constructedListing: ListingResponse<Comment> = ListingResponse(modhash: nil, before: nil, after: nil, dist: nil, children: [newComment])
                    let commentReplyData = CommentReplyData(kind: "t1", data: constructedListing)
                    parentComment.data.replies = commentReplyData
                    print("ok created new constructed listing")
                }
                
                assignNewCommentRepliesToParentComment(newComment, newComments: newComments)
            }
        }
    }
    
    /// searches the tree for a comment instance with the given `fullname` (ie t1_xxxx) format
    private func findCommentWithFullName(_ parentId: String, commentSet: [Comment]) -> Comment? {
        for comment in commentSet {
            guard let commentName = comment.data.name else { return nil }
            if commentName == parentId {
                return comment
            } else if let commentReplies = comment.data.replies?.data?.children {
                if let desiredCommeent = findCommentWithFullName(parentId, commentSet: commentReplies) {
                    return desiredCommeent
                }
            }
        }
        
        return nil
    }
}

// MARK: - Reply to comment
extension PostDetailViewModel {
    
    // need to pass textBoxView because after the comment is successfully created, we need to
    // reset its contents
    func replyToComment(comment: Comment, withText text: String, textBoxView: CommentTextBoxCell?) {
        guard SessionManager.shared.isLoggedIn, let parentId = comment.data.name else { return }
        PostServices.shared.reply(parentId: parentId, text: text) { [weak self] result in
            guard let weakSelf = self else { return }
            switch result {
            case .success(let comments):
                CommentReplyCache.shared.removeValue(forKey: parentId)
                weakSelf.delegate?.postDetailViewModel(weakSelf, didReplyToComment: comment, withNewComment: comments[0])
                textBoxView?.clear()
            case .failure(let error):
                print(error)
            }
        }
    }
}

// MARK: - Reply to Link
extension PostDetailViewModel {
    
    func replyToLink(link: Link, text: String, textBoxView: CommentTextBoxCell) {
        guard SessionManager.shared.isLoggedIn else { return }
        let parentId = link.data.name
        PostServices.shared.reply(parentId: parentId, text: text) { [weak self] result in
            guard let weakSelf = self else { return }
            switch result {
            case .success(let comments):
                weakSelf.delegate?.postDetailViewModel(weakSelf, didReplyToLink: link, withNewComment: comments[0])
                textBoxView.clear()
            case .failure(let error):
                print(error)
            }
        }
    }
}

// MARK: - CommentTableViewCellViewDelegate
extension PostDetailViewModel: CommentTableViewCellViewDelegate {
    func commentTableViewCellView(_ commentTableViewCellView: CommentTableViewCellView, didVote direction: VoteDirection, comment: Comment) {
        guard SessionManager.shared.isLoggedIn else { return }
        PostServices.shared.votePost(id: comment.data.name!, direction: direction) { [weak self] result in
            guard let weakSelf = self else { return }
            weakSelf.delegate?.postDetailViewModel(weakSelf, didVoteOnComment: comment, direction: direction, result: result)
        }
    }
    
    func commentTableViewCellView(_ commentTableViewCellView: CommentTableViewCellView, didSelectReply comment: Comment) {
        guard let _ = dataSource.insertCommentField(forComment: comment) else { return }
        delegate?.postDetailViewModel(self, insertItemAtIndex: IndexSet(integer: 0), forParent: comment)
    }
}

// MARK: - PostDetailHeaderCellDelegate
extension PostDetailViewModel: CommentTextBoxDelegate {
    
    func commentTextBoxCell(_ commentTextBox: CommentTextBoxCell, didSelectSubmit comment: Comment?) {
        delegate?.postDetailViewModel(self, didSelectSubmit: comment!, commentTextBox: commentTextBox)
    }
    
    func commentTextBoxCell(_ commentTextBox: CommentTextBoxCell, didSelectCancel comment: Comment) {
        commentTextBox.clear()
        delegate?.postDetailViewModel(self, didSelectCancel: comment)
    }
}

// MARK: - PostDetailHeaderCellDelegate
extension PostDetailViewModel: PostDetailHeaderCellDelegate {
    func postDetailHeaderCell(_ postDetailHeaderCell: PostDetailHeaderCell, didSelectSubmit commentBox: CommentTextBoxCell) {
        guard let link = self.link else { return }
        replyToLink(link: link, text: commentBox.text, textBoxView: commentBox)
    }
    
    func postDetailHeaderCell(_ postDetailHeaderCell: PostDetailHeaderCell, didSelectBackButton sender: NSButton) {
        delegate?.postDetailViewModel(self, didSelectBackButton: sender)
    }
}
