//
//  CommentListViewController.swift
//  Nicea
//
//  Created by Stephen Bodnar on 4/16/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import AppKit
import APIClient

final class CommentListViewController: NSViewController {
    
    private let scrollView: NSScrollView = NSScrollView()
    private let tableView: NSOutlineView = NSOutlineView()
    
    private let commentDataSource: CommentListDataSource = CommentListDataSource(comments: [])
    private lazy var commentDelegate: CommentListDelegate = {
        return CommentListDelegate(dataSource: commentDataSource, cellDelegate: self, textBoxCellDelegate: self)
    }()
    
    private let viewModel: CommentListViewModel = CommentListViewModel()
    private let indicator: NSActivityIndicator = NSActivityIndicator()
    
    override func loadView() {
        view = NSView()
        layout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        indicator.alphaValue = 1
        indicator.startAnimation(nil)
    }
    
    func setCommentListType(type: CommentListType) {
        viewModel.commentListType = type
    }
}

// MARK: - CommentTextBoxDelegate
extension CommentListViewController: CommentTextBoxDelegate {
    
    func commentTextBoxCell(_ commentTextBox: CommentTextBoxCell, didSelectSubmit comment: Comment?) {
        if let parentComment = tableView.parent(forItem: comment) as? Comment {
            viewModel.replyToComment(comment: parentComment, withText: commentTextBox.text, textBoxView: commentTextBox)
        }
    }
    
    func commentTextBoxCell(_ commentTextBox: CommentTextBoxCell, didSelectCancel comment: Comment) {
        if let parentComment = tableView.parent(forItem: comment) as? Comment {
            commentTextBox.clear()
            commentDataSource.removeInProgressComment(forComment: parentComment)
            tableView.removeItems(at: IndexSet(integer: 0), inParent: parentComment, withAnimation: NSTableView.AnimationOptions.effectFade)
            tableView.reloadItem(parentComment)
        }
    }
}

// MARK: - CommentTableViewCellViewDelegate
extension CommentListViewController: CommentTableViewCellViewDelegate {
    func commentTableViewCelView(_ commentTableViewCellView: CommentTableViewCellView, comment: Comment, didSelectSaveButton button: ClearButton) {
        PostServices.shared.savePost(id: comment.data.name!) { result in
            switch result {
            case .success: button.title = Strings.saveButtonSavedText
            case .failure: button.title = Strings.saveFailedTosave
            }
        }
    }
    
    func commentTableViewCellView(_ commentTableViewCellView: CommentTableViewCellView, didVote direction: VoteDirection, comment: Comment) { }
    
    func commentTableViewCellView(_ commentTableViewCellView: CommentTableViewCellView, didSelectReply comment: Comment) {
        guard let _ = commentDataSource.insertCommentField(forComment: comment) else { return }
        tableView.insertItems(at: IndexSet(integer: 0), inParent: comment, withAnimation: NSTableView.AnimationOptions.effectFade)
        tableView.reloadItem(comment)
        tableView.expandItem(comment, expandChildren: true)
    }
}

// MARK: - MailViewModelDelegate
extension CommentListViewController: CommentListViewModelDelegate {
    
    // called when we successfully respond to a comment
    func commentListViewModel(_ commentListViewModel: CommentListViewModel, didRespondToComment comment: Comment, withNewComment newComment: Comment, inCommentBox commentBox: CommentTextBoxCell?) {
        commentDataSource.removeInProgressComment(forComment: comment)
        self.tableView.removeItems(at: IndexSet(integer: 0), inParent: comment, withAnimation: NSTableView.AnimationOptions.effectFade)
        let listingResponse: ListingResponse<Comment> = ListingResponse(modhash: nil, before: nil, after: nil, dist: nil, children: [newComment])
        comment.data.replies = CommentReplyData(kind: "t1", data: listingResponse)
        self.tableView.insertItems(at: IndexSet(integer: 0), inParent: comment, withAnimation: NSTableView.AnimationOptions.effectFade)
        self.tableView.reloadItem(comment)
        self.tableView.expandItem(comment, expandChildren: true)
        commentBox?.clear()
    }
    
    func commentListViewModel(_ commentListViewModel: CommentListViewModel, didFailToRespondToComment comment: Comment, error: Error) {
        // should probably show error here
    }
    
    func commentListViewModel(_ commentListViewModel: CommentListViewModel, didRetrieveMailbox comments: [Comment]) {
        commentDataSource.items = comments
        indicator.alphaValue = 0
        tableView.alphaValue = 1
        indicator.stopAnimation(nil)
        tableView.reloadData()
        viewModel.markCommentsRead(comments: comments)
        view.window?.title = commentListViewModel.windowTitle
    }
    
    func commentListViewModel(_ commentListViewModel: CommentListViewModel, didFailToMarkCommentsRead error: Error) { }
    func commentListViewModel(_ commentListViewModel: CommentListViewModel, didMarkCommentsRead comments: [Comment]) { }
}

// MARK: - Layout/Setup
extension CommentListViewController {
    
    private func setupViews() {
        view.wantsLayer = true
        viewModel.delegate = self
        
        tableView.delegate = commentDelegate
        tableView.dataSource = commentDataSource
        tableView.register(NSNib(nibNamed: "MailTableViewCell", bundle: nil), forIdentifier: NSUserInterfaceItemIdentifier("MailTableViewCell"))
        tableView.register(NSNib(nibNamed: "CommentTextBoxCell", bundle: nil), forIdentifier: NSUserInterfaceItemIdentifier("CommentTextBoxCell"))
        
        tableView.headerView = nil
        
        let col = NSTableColumn(identifier: NSUserInterfaceItemIdentifier(rawValue: "col"))
        col.width = LayoutConstants.mailOutlineViewWidth
        col.maxWidth = LayoutConstants.mailOutlineViewWidth
        tableView.addTableColumn(col)
        tableView.gridStyleMask = .solidHorizontalGridLineMask
        tableView.alphaValue = 0
        tableView.indentationPerLevel = 15

        scrollView.documentView = tableView
    }
    
    private func layout() {
        scrollView.setupForAutolayout(superView: view)
        tableView.setupForAutolayout(superView: scrollView)
        indicator.setupForAutolayout(superView: view)
        
        let insets: NSEdgeInsets = LayoutConstants.mailTableViewInsets
        
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50).activate()
        scrollView.widthAnchor.constraint(equalToConstant: LayoutConstants.mailWindowControllerDefaultRect.width).activate()
        scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: insets.top).activate()
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: insets.bottom).activate()
        
        indicator.center(in: view)
    }
}
