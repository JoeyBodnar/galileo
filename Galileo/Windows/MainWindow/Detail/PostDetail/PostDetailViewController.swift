//
//  PostDetailView.swift
//  Nicea
//
//  Created by Stephen Bodnar on 4/2/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import AppKit
import APIClient

protocol PostDetailViewControllerDelegate: AnyObject {
    
    func postDetailViewController(_ postDetailViewController: PostDetailViewController, didSelectBackButton sender: NSButton)
}

/// Displays an individual post and its comments
final class PostDetailViewController: NSViewController {
    
    private let scrollView: NSScrollView = NSScrollView()
    private let outlineView: NSOutlineView = NSOutlineView()
    
    let viewModel: PostDetailViewModel = PostDetailViewModel()
    
    weak var delegate: PostDetailViewControllerDelegate?
    private let indicator: NSActivityIndicator = NSActivityIndicator()
    
    override init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nil)
    }

    override func loadView() {
        view = NSView()
        view.wantsLayer = true
        layoutViews()
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension PostDetailViewController: PostDetailViewModelDelegate {
    
    func postDetailViewMode(_ postDetailViewModel: PostDetailViewModel, didSelectArticleLink button: ClearButton, cell: PostDetailHeaderCell) {
        guard let link = viewModel.dataSource.comments[outlineView.row(for: cell)] as? Link else {
            return
        }
        guard let urlString: String = link.data.url else { return }
        
        WebViewWindowController.present(urlString: urlString, fromVc: self)
    }
    
    func postDetailViewModel(_ postDetailViewModel: PostDetailViewModel, didVoteOnComment comment: Comment, direction: VoteDirection, result: Result<Bool, Error>) {
        switch result {
        case .success:
            print("voting succeeded")
            comment.data.likes = direction == .up ? true : false
        case .failure: break
        }
    }
    
    func postDetailViewModel(_ postDetailViewModel: PostDetailViewModel, didReplyToLink link: Link, withNewComment newComment: Comment) {
        viewModel.dataSource.comments.insert(newComment, at: 1)
        outlineView.insertItems(at: IndexSet(integer: 1), inParent: nil, withAnimation: NSTableView.AnimationOptions.effectFade)
    }
    
    
    func postDetailViewModel(_ postDetailViewModel: PostDetailViewModel, didSelectBackButton sender: NSButton) {
        delegate?.postDetailViewController(self, didSelectBackButton: sender)
    }
    
    func postDetailViewModel(_ postDetailViewModel: PostDetailViewModel, didSelectSubmit comment: Comment, commentTextBox: CommentTextBoxCell) {
        if let parentComment = outlineView.parent(forItem: comment) as? Comment {
            viewModel.replyToComment(comment: parentComment, withText: commentTextBox.text, textBoxView: commentTextBox)
        }
    }
    
    func postDetailViewModel(_ postDetailViewModel: PostDetailViewModel, didReplyToComment comment: Comment, withNewComment newComment: Comment) {
        viewModel.dataSource.removeInProgressComment(forComment: comment)
        self.outlineView.removeItems(at: IndexSet(integer: 0), inParent: comment, withAnimation: NSTableView.AnimationOptions.effectFade)
        if let currentReplies = comment.data.replies {
            currentReplies.data?.children?.insert(newComment, at: 0)
        }
        self.outlineView.insertItems(at: IndexSet(integer: 0), inParent: comment, withAnimation: NSTableView.AnimationOptions.effectFade)
        self.outlineView.reloadItem(comment)
        viewModel.isAutoExpanding = true
        self.outlineView.expandItem(comment, expandChildren: true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) { [weak self] in
            self?.viewModel.isAutoExpanding = false
        }
    }
    
    func postDetailViewModel(_ postDetailViewModel: PostDetailViewModel, didSelectCancel comment: Comment) {
        if let parentComment = outlineView.parent(forItem: comment) as? Comment {
            viewModel.dataSource.removeInProgressComment(forComment: parentComment)
            outlineView.removeItems(at: IndexSet(integer: 0), inParent: parentComment, withAnimation: NSTableView.AnimationOptions.effectFade)
            outlineView.reloadItem(parentComment)
        }
    }
    
    func postDetailViewModel(_ postDetailViewModel: PostDetailViewModel, insertItemAtIndex index: IndexSet, forParent parent: Comment) {
        outlineView.insertItems(at: index, inParent: parent, withAnimation: NSTableView.AnimationOptions.effectFade)
        outlineView.reloadItem(parent)
        viewModel.isAutoExpanding = true
        outlineView.expandItem(parent, expandChildren: true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) { [weak self] in
            self?.viewModel.isAutoExpanding = false
        }
    }
    
        
    func postDetailViewModel(_ postDetailViewModel: PostDetailViewModel, didRetrieveComments commentResponse: [Comment]) {
        indicator.stopAnimation(nil)
        indicator.alphaValue = 0
        self.viewModel.isAutoExpanding = true
        self.outlineView.alphaValue = 1
        self.outlineView.reloadData()
        for i in commentResponse {
            self.outlineView.expandItem(i, expandChildren: true)
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) { [weak self] in
            self?.viewModel.isAutoExpanding = false
        }
    }
}

// MARK: Layout/Setup
extension PostDetailViewController {
    
    private func setupViews() {
        viewModel.delegate = self
        indicator.alphaValue = 1
        indicator.startAnimation(nil)
        
        scrollView.wantsLayer = true
        outlineView.wantsLayer = true
        
        scrollView.documentView = outlineView
        scrollView.hasHorizontalScroller = false
        scrollView.hasVerticalScroller = true
        scrollView.horizontalScrollElasticity = .none
        scrollView.layer?.backgroundColor = NSColor.blue.cgColor
    }
    
    private func layoutViews() {
        outlineView.dataSource = viewModel.dataSource
        outlineView.delegate = viewModel.outlineViewDelegate
        
        outlineView.register(NSNib(nibNamed: "CommentCell", bundle: nil), forIdentifier: NSUserInterfaceItemIdentifier(rawValue: "CommentCell"))
        outlineView.register(NSNib(nibNamed: "CommentLoadingCell", bundle: nil), forIdentifier: NSUserInterfaceItemIdentifier(rawValue: "CommentLoadingCell"))
        outlineView.register(NSNib(nibNamed: "CommentTextBoxCell", bundle: nil), forIdentifier: NSUserInterfaceItemIdentifier(rawValue: "CommentTextBoxCell"))
        outlineView.register(NSNib(nibNamed: "PostDetailHeaderCell", bundle: nil), forIdentifier: NSUserInterfaceItemIdentifier(rawValue: "PostDetailHeaderCell"))
        
        outlineView.gridStyleMask = .solidHorizontalGridLineMask
        outlineView.indentationPerLevel = 15
        outlineView.wantsLayer = true
        outlineView.layer?.backgroundColor = NSColor.orange.cgColor
        outlineView.headerView = nil
        let col = NSTableColumn(identifier: NSUserInterfaceItemIdentifier(rawValue: "col"))
        col.width = LayoutConstants.postDetailOutlineViewWidth
        col.maxWidth = LayoutConstants.postDetailOutlineViewWidth
        outlineView.addTableColumn(col)
        outlineView.alphaValue = 0
        
        scrollView.setupForAutolayout(superView: view)
        indicator.setupForAutolayout(superView: view)
        
        indicator.center(in: view)
        
        scrollView.pinToSides(superView: view)
        scrollView.documentView = outlineView
    }
}
