//
//  MailViewController.swift
//  Nicea
//
//  Created by Stephen Bodnar on 4/16/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import AppKit
import APIClient

final class MailViewController: NSViewController {
    
    private let scrollView: NSScrollView = NSScrollView()
    private let tableView: NSOutlineView = NSOutlineView()
    
    private let mailViewDataSource: MailViewDataSource = MailViewDataSource(comments: [])
    private lazy var mailViewDelegate: MailViewDelegate = {
        return MailViewDelegate(dataSource: mailViewDataSource, cellDelegate: self, textBoxCellDelegate: self)
    }()
    
    private let viewModel: MailViewModel = MailViewModel()
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
        viewModel.getMailbox()
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        view.window?.title = "Mailbox"
    }
}

// MARK: - CommentTextBoxDelegate
extension MailViewController: CommentTextBoxDelegate {
    
    func commentTextBoxCell(_ commentTextBox: CommentTextBoxCell, didSelectSubmit comment: Comment?) {
        if let parentComment = tableView.parent(forItem: comment) as? Comment {
            viewModel.replyToComment(comment: parentComment, withText: commentTextBox.text, textBoxView: commentTextBox)
        }
    }
    
    func commentTextBoxCell(_ commentTextBox: CommentTextBoxCell, didSelectCancel comment: Comment) {
        if let parentComment = tableView.parent(forItem: comment) as? Comment {
            commentTextBox.clear()
            mailViewDataSource.removeInProgressComment(forComment: parentComment)
            tableView.removeItems(at: IndexSet(integer: 0), inParent: parentComment, withAnimation: NSTableView.AnimationOptions.effectFade)
            tableView.reloadItem(parentComment)
        }
    }
}

// MARK: - CommentTableViewCellViewDelegate
extension MailViewController: CommentTableViewCellViewDelegate {
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
        guard let _ = mailViewDataSource.insertCommentField(forComment: comment) else { return }
        tableView.insertItems(at: IndexSet(integer: 0), inParent: comment, withAnimation: NSTableView.AnimationOptions.effectFade)
        tableView.reloadItem(comment)
        tableView.expandItem(comment, expandChildren: true)
    }
}

// MARK: - MailViewModelDelegate
extension MailViewController: MailViewModelDelegate {
    
    // called when we successfully respond to a comment
    func mailViewModel(_ mailViewModel: MailViewModel, didRespondToComment comment: Comment, withNewComment newComment: Comment, inCommentBox commentBox: CommentTextBoxCell?) {
        mailViewDataSource.removeInProgressComment(forComment: comment)
        self.tableView.removeItems(at: IndexSet(integer: 0), inParent: comment, withAnimation: NSTableView.AnimationOptions.effectFade)
        let listingResponse: ListingResponse<Comment> = ListingResponse(modhash: nil, before: nil, after: nil, dist: nil, children: [newComment])
        comment.data.replies = CommentReplyData(kind: "t1", data: listingResponse)
        self.tableView.insertItems(at: IndexSet(integer: 0), inParent: comment, withAnimation: NSTableView.AnimationOptions.effectFade)
        self.tableView.reloadItem(comment)
        self.tableView.expandItem(comment, expandChildren: true)
        commentBox?.clear()
    }
    
    func mailViewModel(_ mailViewModel: MailViewModel, didFailToRespondToComment comment: Comment, error: Error) {
        // should probably show error here
    }
    
    func mailViewModel(_ mailViewModel: MailViewModel, didRetrieveMailbox comments: [Comment]) {
        mailViewDataSource.items = comments
        indicator.alphaValue = 0
        tableView.alphaValue = 1
        indicator.stopAnimation(nil)
        tableView.reloadData()
        viewModel.markCommentsRead(comments: comments)
    }
    
    func mailViewModel(_ mailViewModel: MailViewModel, didFailToMarkCommentsRead error: Error) { }
    func mailViewModel(_ mailViewModel: MailViewModel, didMarkCommentsRead comments: [Comment]) { }
}

// MARK: - Layout/Setup
extension MailViewController {
    
    private func setupViews() {
        view.wantsLayer = true
        viewModel.delegate = self
        
        tableView.delegate = mailViewDelegate
        tableView.dataSource = mailViewDataSource
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
