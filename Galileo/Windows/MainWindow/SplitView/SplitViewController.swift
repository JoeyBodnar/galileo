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
        detailViewController?.delegate = self
        
        let sidebarItem: NSSplitViewItem = NSSplitViewItem(sidebarWithViewController: sidebarViewController!)
        sidebarItem.minimumThickness = 203
        sidebarItem.maximumThickness = 203
        
        splitViewItems = [sidebarItem, NSSplitViewItem(contentListWithViewController: detailViewController!)]
    }
}

extension SplitViewController: DetailViewControllerDelegate {
    
    func detailViewController(_ detailViewController: DetailViewController, subredditDidChange subreddit: String) {
        let lowercased: String = subreddit.lowercased()
        if lowercased == "all" || lowercased == "home" || lowercased == "popular" {
            sidebarViewController?.viewModel.searchSubredditItem = SearchSubredditItem.all
        } else {
            sidebarViewController?.viewModel.searchSubredditItem = SearchSubredditItem.subreddit(subreddit: subreddit)
        }
    }
}

extension SplitViewController: SidebarViewControllerDelegate {
    
    func sidebarViewController(_ sidebarViewController: SidebarViewController, searchPressed searchField: NSSearchField) {
        detailViewController?.postListViewController.viewModel.handleSearchPressed(text: searchField.stringValue)
        detailViewController?.searchPressed()
    }
    
    func sidebarViewController(_ sidebarViewController: SidebarViewController, searchTypeDidChange searchType: SearchType) {
        detailViewController?.postListViewController.viewModel.searchType = searchType
    }
    
    func sidebarViewController(_ sidebarViewController: SidebarViewController, didSelectItem item: SidebarItem) {
        switch item {
        case .search, .searchOptions: break
        case .trendingSubreddit(let name, _):
            detailViewController?.didSelectNewSubreddit(subreddit: name, isHomeFeed: false)
        case .subscriptionSubreddit(let subreddit):
            guard let subredditName = subreddit.data.displayName else { return }
            detailViewController?.didSelectNewSubreddit(subreddit: subredditName, isHomeFeed: false)
        case .defaultRedditFeed(let name, _):
            detailViewController?.didSelectNewSubreddit(subreddit: name, isHomeFeed: name.lowercased() == "home")
        }
    }
}
