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
            detailViewController?.didSelectNewSubreddit(subreddit: unwrappedInitialSubreddit, isHomeFeed: false)
        } else if SessionManager.shared.isLoggedIn {
            detailViewController?.didSelectNewSubreddit(subreddit: "home", isHomeFeed: true)
        } else {
            detailViewController?.didSelectNewSubreddit(subreddit: "popular", isHomeFeed: false)
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
    
    func didSelectItem(item: SidebarItem) {
        switch item {
        case .search: break
        case .trendingSubreddit(let name, _):
            detailViewController?.didSelectNewSubreddit(subreddit: name, isHomeFeed: false)
        case .subscriptionSubreddit(let subreddit):
            guard let subredditName = subreddit.data.displayName else { return }
            detailViewController?.didSelectNewSubreddit(subreddit: subredditName, isHomeFeed: false)
        case .defaultRedditFeed(let name, _):
            detailViewController?.didSelectNewSubreddit(subreddit: name, isHomeFeed: name.lowercased() == "home")
        }
        
        sidebarViewController?.viewModel.getCurrentUser()
    }
    
}
