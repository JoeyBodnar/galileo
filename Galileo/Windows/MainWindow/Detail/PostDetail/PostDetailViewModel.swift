//
//  PostDetailViewModel.swift
//  Nicea
//
//  Created by Stephen Bodnar on 4/4/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import AppKit
import APIClient

enum CommentSort: String {
    
    case best
    case hot
    case top
    case new
    case controversial
}

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
    
    var currentSort: CommentSort = .best
    
    /// passing in nil as sort will load the default sort used by reddit
    func loadArticleAndComments(for link: Link, sort: CommentSort?) {
        PostServices.shared.getComments(subreddit: link.data.subreddit, articleId: link.data.id, isLoggedIn: SessionManager.shared.isLoggedIn, sort: sort?.rawValue) { [weak self] result in
            switch result {
            case .success(let commentResponse):
                self?.handleDidLoadInitialComments(commentResponse: commentResponse, originalLink: link)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func loadMoreCommentsOnParentArticle(comment: Comment) {
        guard let children = comment.data.commentChildren, let parentId = link?.data.name else { return }
        
        PostServices.shared.getMoreComments(subreddit: subreddit, parentId: parentId, childrenIds: children, sort: currentSort.rawValue) { [weak self] result in
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
        let commentsOnParentPost: [Comment] = comments.filter { comment -> Bool in
            let matchesParent: Bool = comment.data.parentId! == parentId
            let isTopLevel = comment.isTopLevelComment
            return matchesParent && isTopLevel
        }
        
        // then append
        dataSource.comments.append(contentsOf: commentsOnParentPost)
        
        // comments not on the parent post, but responding to other comments
        let commentChildren: [Comment] = comments.filter { comment -> Bool in
            guard let commentParendId = comment.data.parentId else { return false }
            let first2: String = String(commentParendId.prefix(2))
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
    func commentTableViewCelView(_ commentTableViewCellView: CommentTableViewCellView, comment: Comment, didSelectSaveButton button: ClearButton) {
        PostServices.shared.savePost(id: comment.data.name!) { result in
            switch result {
            case .success: button.title = Strings.saveButtonSavedText
            case .failure: button.title = Strings.saveFailedTosave
            }
        }
    }
    
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
    
    func postDetailHeaderCell(_ postDetailHeaderCell: PostDetailHeaderCell, didSelectSort sort: String) {
        guard let unwrappedLink = link else { return }
        if let commentSort = CommentSort(rawValue: sort.lowercased()) {
            currentSort = commentSort
            loadArticleAndComments(for: unwrappedLink, sort: commentSort)
        }
    }
    
    func postDetailHeaderCell(_ postDetailHeaderCell: PostDetailHeaderCell, didSelectLink linkButton: ClearButton) {
        delegate?.postDetailViewMode(self, didSelectArticleLink: linkButton, cell: postDetailHeaderCell)
    }
    
    func postDetailHeaderCell(_ postDetailHeaderCell: PostDetailHeaderCell, didSelectSubmit commentBox: CommentTextBoxCell) {
        guard let link = self.link else { return }
        replyToLink(link: link, text: commentBox.text, textBoxView: commentBox)
    }
    
    func postDetailHeaderCell(_ postDetailHeaderCell: PostDetailHeaderCell, didSelectBackButton sender: NSButton) {
        delegate?.postDetailViewModel(self, didSelectBackButton: sender)
    }
}
