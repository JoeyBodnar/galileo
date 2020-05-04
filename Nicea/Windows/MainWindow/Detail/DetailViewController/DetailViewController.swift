//
//  DetailViewController.swift
//  Nicea
//
//  Created by Stephen Bodnar on 3/24/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import AppKit
import APIClient

protocol DetailViewControllerDelegate: AnyObject {
    
    func detailViewController(_ detailViewController: DetailViewController, subredditDidChange subreddit: String)
}

final class DetailViewController: NSViewController {
    
    var postDetailViewController: PostDetailViewController?
    let postListViewController: PostListViewController = PostListViewController()
    
    weak var delegate: DetailViewControllerDelegate?
    
    override init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func loadView() {
        view = NSView()
        view.wantsLayer = true
        layoutViews()
        setupViews()
    }
    
    func showPostsDetail(link: Link) {
        postListViewController.view.alphaValue = 0
        addPostsDetailView(link: link)
    }
    
    func hidePostsDetail() {
        postDetailViewController?.view.alphaValue = 0
        postDetailViewController?.view.removeFromSuperview()
        postDetailViewController = nil
    }
    
    private func addPostsDetailView(link: Link) {
        postDetailViewController = PostDetailViewController()
        postDetailViewController?.delegate = self
        postDetailViewController?.viewModel.link = link
        postDetailViewController?.viewModel.loadArticleAndComments(for: link)
        postDetailViewController?.view.setupForAutolayout(superView: view)
        postDetailViewController?.view.pinToSides(superView: view)
    }
    
    func didSelectNewSubreddit(subreddit: String, isHomeFeed: Bool) {
        postDetailViewController?.view.alphaValue = 0
        postDetailViewController?.view.removeFromSuperview()
        
        postListViewController.setLoading(true, isNewSubreddit: true)
        postListViewController.viewModel.didSelectSubreddit(subreddit: subreddit, isHomeFeed: isHomeFeed)
    }
}

extension DetailViewController: PostDetailViewControllerDelegate {
    
    func postDetailViewController(_ postDetailViewController: PostDetailViewController, didSelectBackButton sender: NSButton) {
        hidePostsDetail()
    }
}

extension DetailViewController: PostListViewControllerDelegate {
    
    func postListViewController(_ postListViewController: PostListViewController, subredditDidChange subreddit: String) {
        delegate?.detailViewController(self, subredditDidChange: subreddit)
    }
    
    func postListViewController(_ postListViewController: PostListViewController, didSelectViewComments link: Link) {
        addPostsDetailView(link: link)
    }
}

extension DetailViewController {
    
    private func setupViews() {
        postListViewController.delegate = self
    }
    
    private func layoutViews() {
        postListViewController.view.setupForAutolayout(superView: view)
        postListViewController.view.pinToSides(superView: view)
    }
}
