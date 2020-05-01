//
//  SplitViewController.swift
//  Nicea
//
//  Created by Stephen Bodnar on 3/24/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import AppKit
import APIClient

final class SplitViewController: NSSplitViewController {
    
    var sidebarViewController: SidebarViewController?
    var detailViewController: DetailViewController?
    
    /// set from MainWindowController
    var initialSubreddit: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Setup API Client
        RedditClient.shared.apiClient.authToken = DefaultsManager.shared.userAuthorizationToken
        RedditClient.shared.apiClient.refreshToken = DefaultsManager.shared.userRefreshToken
        
        setupSplitItems()
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        loadInitialSubreddit()
    }
    
    private func loadInitialSubreddit() {
        if let unwrappedInitialSubreddit = initialSubreddit {
            didSelectItem(item: unwrappedInitialSubreddit)
        } else if SessionManager.shared.isLoggedIn {
            didSelectItem(item: SidebarDefaultItem(title: "Home", imageName: ""))
        } else {
            didSelectItem(item: "popular")
        }
    }
}

extension SplitViewController {
    
    private func setupSplitItems() {
        self.sidebarViewController = SidebarViewController()
        self.detailViewController = DetailViewController()
        sidebarViewController?.delegate = self
        
        let sidebarItem: NSSplitViewItem = NSSplitViewItem(sidebarWithViewController: sidebarViewController!)
        sidebarItem.minimumThickness = 203
        sidebarItem.maximumThickness = 203
        
        splitViewItems = [sidebarItem, NSSplitViewItem(contentListWithViewController: detailViewController!)]
    }
}

extension SplitViewController: SidebarViewControllerDelegate {
    
    func didSelectItem(item: Any) {
        if let subreddit = item as? Subreddit {
            detailViewController?.didSelectNewSubreddit(subreddit: subreddit.data.displayName!, isHomeFeed: false)
        } else if let trendingSubreddit = item as? String {
            detailViewController?.didSelectNewSubreddit(subreddit: trendingSubreddit, isHomeFeed: false)
        } else if let defaltFeedSubreddit = item as? SidebarDefaultItem {
            detailViewController?.didSelectNewSubreddit(subreddit: defaltFeedSubreddit.title, isHomeFeed: defaltFeedSubreddit.title == "Home")
        }
        
        sidebarViewController?.viewModel.getCurrentUser()
    }
    
}
